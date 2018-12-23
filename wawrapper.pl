#!/usr/bin/env perl
use utf8;
#
# Wrapper for executing WebAssembly. Copyright © 2018 Alex Smith.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# The purpose of this program is to autodetect the format of a
# WebAssembly-ish file, and compile and run it. The assumption is that
# the file was entered by a user in some sort of text format (thus, a
# binary .wasm file would have been encoded to make it human-readable);
# this program will not work on unmodified binary .wasm files.
#
# This program takes input in any of the following formats:
# - WebAssembly .wasm, interpreted in codepage 437 and encoded as UTF-8
#   (using ∅, ␣, ⍽ as NUL, space, NBSP)
# - WebAssembly .wast, full program in ASCII
# - WebAssembly .wast, "data" and "func" sections only
# and uses the tools provided by WAVM to compile and run the program.
#
# One option is available: -f. This will output the assembled and
# disassembled representation of the program on standard error,
# together with some statistics about its size.

use warnings;
use strict;
use feature 'unicode_strings';
use autodie qw/open close system/;
use open IO => ':utf8', ':std';
$| = 1;

use Encode;
use File::Temp;
use FindBin;
use Getopt::Std;

use lib "$FindBin::Bin/lib";
use WaWrapper::Imports;

# Change this if necessary.
use constant path_to_WAVM => "$FindBin::Bin/../prefix/bin";

$Getopt::Std::STANDARD_HELP_VERSION = 1;
our $opt_f;
getopts('f');

sub errexit {
    print STDERR "Error: $_[0]\n";
    exit 1;
}

# The codepage 437 charset, with three substitutions to make invisible
# characters visible.
my $charset =
    '∅☺☻♥♦♣♠•◘○◙♂♀♪♫☼►◄↕‼¶§▬↨↑↓←→∟↔▲▼␣' .
    decode('IBM-437', join '', map chr,  33..126) . '⌂' .
    decode('IBM-437', join '', map chr, 128..254) . '⍽';

undef $/;
my $program = <>;
my $decoded = '';
my $respect_ws = 1;
for my $char (split //, $program) {
    my $index = index $charset, $char;
    $char =~ /\s/ and next unless $respect_ws;
    $char eq " " and $index = 32;
    $char eq "\t" and $index = 9;
    $char eq "\n" and $index = 10;
    $char eq "\xA0" and $index = 255;
    $index < 0 and errexit "Unrecognised character '$char'";
    $index == 0 and $respect_ws = 0;
    $decoded .= chr $index;
}
$program = $decoded;

if ($program !~ /[^\t\n -~]/ &&
    $program =~ /^\s*\(\s*(data|elem|func|global)\b/) {
    # This looks like WASM without (some of) the imports and exports.
    # So we're going to have to generate them ourselves.
    my %seen;
    my $header = ' (export "main" (func $main))' . "\n";
    while ($program =~ m/\$(\w+)/g) {
        my $varname = $1;
        next if $seen{$varname}++;
        my $impname = $varname;
        exists $WaWrapper::Imports::env_imports{$impname} or
            $impname = "_$impname";
        my $sig = $WaWrapper::Imports::env_imports{$impname};
        if (defined $sig) {
            $header .= " (import \"env\" \"$impname\"";
            if ($sig =~ /^(\w+)\s*\((.*)\)$/) {
                # It's a function.
                my $return_type = $1;
                my $arg_types = $2;
                $arg_types =~ s/\bu(32|64)\b/i$1/g;
                $return_type =~ s/\bu(32|64)\b/i$1/g;
                my @arg_types = split /,\s*/, $arg_types;
                $header .= " (func \$$varname";
                $header .= " (param @arg_types)"
                    unless $arg_types eq '';
                $header .= " (result $return_type)"
                    unless $return_type eq 'void';
                $header .= "))\n";
            } else {
                # It's a global variable.
                $header .= " (global \$$varname $sig))\n";
            }
        }
    }
    $header .= ' (import "env" "memory" (memory 4096))'."\n";
    $program = "(module\n$header$program)";
}

my $tempdir = File::Temp->newdir();
my $wasm;

if ($program =~ /^\s*\(\s*module/) {
    # What we have now is WAST. Assemble it to WASM.
    open my $wast_out, ">", "$tempdir/a.wast";
    print $wast_out $program;
    close $wast_out;

    system path_to_WAVM."/wavm-as", "$tempdir/a.wast", "$tempdir/a.wasm";

    open my $wasm_in, "<:bytes", "$tempdir/a.wasm";
    $wasm = <$wasm_in>;
    close $wasm_in;
} else {
    # What we have now is WASM.
    open my $wasm_out, ">:bytes", "$tempdir/a.wasm";
    print $wasm_out $program;
    close $wasm_out;
    $wasm = $program;
}

if ($opt_f) {
    # Disassemble the WASM to WAST. We do this even if the source was WAST, as
    # a method of pretty-printing.
    system path_to_WAVM."/wavm-disas", "$tempdir/a.wasm", "$tempdir/a.wast";
    open my $wast_in, "<", "$tempdir/a.wast";
    my $wast = <$wast_in>;
    close $wast_in;
    $wast =~ s/\s*\n\s*\)/)/g;
    $wast =~ s/\s*\n\s*\(result\b/ (result/g;
    $wast =~ s/\n*\z//;

    my $encoded_wasm = '';
    for my $char (split //, $wasm) {
        $encoded_wasm .= substr $charset, ord($char), 1;
    }

    my $bytes = length $encoded_wasm;
    $encoded_wasm =~ s/(.{80})/$1\n/g;
    $encoded_wasm =~ s/\n\z//;
    print STDERR "Pretty-printed WebAssembly:\n<pre>\n$wast\n</pre>\n\n";
    print STDERR "Compiled WebAssembly binary ($bytes bytes):\n";
    print STDERR "<pre>\n$encoded_wasm\n</pre>\n";
}

# Run the program.
{
    no autodie 'system';
    my $exitcode = system path_to_WAVM."/wavm-run", "$tempdir/a.wasm";
    exit ($exitcode >> 8);
}

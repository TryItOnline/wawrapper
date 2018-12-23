WaWrapper
=========

WaWrapper is a wrapper script intended for running
[WebAssembly](https://webassembly.org) source code.  Most of the actual
work is done via delegating to a WebAssembly virtual machine, which must
be provided by the user. (Currently, WaWrapper is compatible only with
[WAVM](https://github.com/WAVM/WAVM).)

Usage
-----

WaWrapper is intended for use as a backend for sites which allow the
user to enter the source code for a program, and which compile and run
it. As such, the usual source format is the textual `.wast` / `.wat`
format.

Users may not want to write out an entire WebAssembly file; some parts,
such as the imports and exports, can be determined automatically. As
such, WaWrapper supports a situation in which the user enters only the
data, globals, and functions that make up their code; imports will
automatically be added for any functions in module `env` that WAVM
supports and that are used in the user's code, and for 256 MiB of
memory; and an export will be added for a function `main` that takes no
arguments and returns a 32-bit integer exit code (which will be
interpreted as an 8-bit integer and used as WaWrapper's exit code), in
addition to a `module` wrapper for the module itself.  The file
extension `.waw` is used for this sort of "`.wast` missing imports"
file.

WaWrapper also allows users to enter their own compiled `.wasm` files.
However, as such files contain many nonprintable characters (especially
NUL), a different encoding needs to be used to make this possible. As
such, WaWrapper accepts a format consisting of a `.wasm` file
interpreted as characters in codepage 437 and encoded as UTF-8, but with
three substitutions:

  * NUL (codepoint 0): encoded as `∅`, not NUL
  * Space (codepoint 32): encoded as `␣`, not ` `
  * Non-breaking space (codepoint 255): encoded as `⍽`, not ` `

Note that the full version of codepage 437 is used, e.g. codepoint 127
is encoded as `⌂` not DEL, and codepoint 10 as `◙` not NL.

Because this encoding uses no whitespace characters, whitespace can
freely be added to avoid issues with systems that use long lines. The
filename extension `.wae` is used for this "encoded" form of `.wasm`.

WaWrapper accepts only one command-line option (besides the name of the
file to execute), `-f`. If this is given, in addition to executing the
file, WaWrapper will translate the file to both `.wasm` (encoded using
the format above), and a pretty-printed form of `.wast` (including all
imports, elidable type information, etc.); these will be output on
standard error.


Installation
------------

WaWrapper is a standalone Perl script `wawrapper.pl`, that can be
executed directly from an unpacked version of its installation tarball
(it looks at some files relative to itself, so the directory structure
should be left the same).

The only potentially tricky part is that WaWrapper will need to be given
the path to WAVM. The current version of the script assumes a parallel
install, with WAVM's binaries in `../prefix/bin` relative to
`wawrapper.pl`; you can easily change this via editing the
`path_to_WAVM` constant in `wawrapper.pl`.


Legal
-----

WaWrapper is licensed under the Apache license version 2. See the
`COPYING` file for more information.

The file `lib/WaWrapper/Imports.pm` is a listing of which imports are
supported by WAVM. As such, it is licensed under the same terms as WAVM,
a 3-clause BSD-style license; see its copyright header for more
information.

THERE IS NO WARRANTY FOR ANY OF THIS.

# Definitions of what WaWrapper can import.
#
# This file was written by Alex Smith, but is a derivative work of
# "WAVM" by Andrew Scheidecker, in that it lists what choices WAVM
# made about what functions it supports.
#
# Copyright (c) 2018, Alex Smith
# Copyright (c) 2018, Andrew Scheidecker
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
# * Neither the name of WAVM nor the names of its contributors may be
#   used to endorse or promote products derived from this software
#   without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# <COPYRIGHT HOLDER> BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
# 

package WaWrapper::Imports;
use warnings;
use strict;

our %env_imports = (
    DYNAMICTOP_PTR => 'u32',
    EMTSTACKTOP => 'u32',
    EMT_STACK_MAX => 'u32',
    STACKTOP => 'i32',
    STACK_MAX => 'i32',
    __memory_base => 'u32',
    __table_base => 'u32',
    _environ => 'u32',
    _stderr => 'i32',
    _stdin => 'i32',
    _stdout => 'i32',
    eb => 'i32',
    memoryBase => 'u32',
    tableBase => 'u32',
    tempDoublePtr => 'i32',

    __ZSt18uncaught_exceptionv => 'i32 ()',
    ___assert_fail => 'void (i32, i32, i32)',
    ___ctype_b_loc => 'u32 ()',
    ___ctype_tolower_loc => 'u32 ()',
    ___ctype_toupper_loc => 'u32 ()',
    ___cxa_allocate_exception => 'u32 (u32)',
    ___cxa_atexit => 'i32 (i32, i32, i32)',
    ___cxa_begin_catch => 'i32 (i32)',
    ___cxa_guard_aquire => 'i32 (u32)',
    ___cxa_guard_release => 'void (i32)',
    ___cxa_throw => 'void (i32, i32, i32)',
    ___errno_location => 'i32 ()',
    ___lock => 'void (i32)',
    ___lockfile => 'i32 (i32)',
    ___setErrNo => 'void (i32)',
    ___syscall140 => 'i32 (i32, i32)',
    ___syscall145 => 'i32 (i32, i32)',
    ___syscall146 => 'i32 (i32, u32)',
    ___syscall54 => 'i32 (i32, i32)',
    ___syscall6 => 'i32 (i32, i32)',
    ___unlock => 'void (i32)',
    ___unlockfile => 'void (i32)',
    _abort => 'void ()',
    _catclose => 'i32 (i32)',
    _catgets => 'i32 (i32, i32, i32, i32)',
    _catopen => 'i32 (i32, i32)',
    _emscripten_memcpy_big => 'u32 (u32, u32, u32)',
    _exit => 'void (i32)',
    _fflush => 'i32 (i32)',
    _fputc => 'i32 (i32, i32)',
    _fread => 'u32 (u32, u32, u32, i32)',
    _freelocale => 'void (i32)',
    _fwrite => 'u32 (u32, u32, u32, i32)',
    _getc => 'i32 (i32)',
    _newlocale => 'u32 (i32, i32, i32)',
    _pthread_cleanup_pop => 'void (i32)',
    _pthread_cleanup_push => 'void (i32, i32)',
    _pthread_cond_broadcast => 'i32 (i32)',
    _pthread_cond_wait => 'i32 (i32, i32)',
    _pthread_getspecific => 'i32 (u32, u32)',
    _pthread_key_create => 'i32 (u32, i32)',
    _pthread_mutex_lock => 'i32 (i32)',
    _pthread_mutex_unlock => 'i32 (i32)',
    _pthread_once => 'i32 (i32, i32)',
    _pthread_self => 'i32 ()',
    _pthread_setspecific => 'i32 (u32, i32)',
    _strerror => 'i32 (i32)',
    _strftime_l => 'i32 (i32, i32, i32, i32, i32)',
    _sysconf => 'i32 (i32)',
    _time => 'i32 (u32)',
    _ungetc => 'i32 (i32)',
    _uselocale => 'i32 (i32)',
    _vfprintf => 'i32 (i32, u32, i32)',
    abort => 'void (i32)',
    abortOnCannotGrowMemory => 'i32 ()',
    abortStackOverflow => 'void (i32)',
    enlargeMemory => 'i32 ()',
    getTotalMemory => 'u32 ()',
);

1;

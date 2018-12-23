(module
 (export "main" (func $main))
 (import "env" "_fwrite" (func $fwrite (param i32 i32 i32 i32) (result i32)))
 (import "env" "_stdout" (global $stdout i32))
 (import "env" "memory" (memory 1))
 (data (i32.const 0) "Hello, World!\n")
 (func $main (result i32)
  i32.const 0
  i32.const 1
  i32.const 14
  get_global $stdout
  call $fwrite
  drop
  i32.const 0
  return))

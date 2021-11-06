# bf-interpreters
Interpreters in a variety of languages for [Brainfuck](https://esolangs.org/wiki/brainfuck), an esoteric programming language.

Has interpreters in:
- C
- C++
- Go
- Java
- Javascript
- Python
- Rust
- Zig

Each interpreter:
- Can be run with a single argument like `bf <code>` to run `<code>`, like
  ```shell
  $ bf "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
  Hello World!
  ```
- Can be run with no arguments to open a REPL interface.

Some interpreters can do more than that, but each can do at least that. Implementation-specific
information and instructions on how to run an interpreter can be found at the top of its source file.

# bf-interpreters
Interpreters for [Brainfuck](https://esolangs.org/wiki/brainfuck), an esoteric programming language.

Each interpreter:
- Can be run with a single argument like `bf <code>` to run `<code>`, like
  ```shell
  $ PRINT_PUNC="+++++++++++++++++++++++++++++++++.+.+.+."
  $ bf $PRINT_PUNC
  !"#$
  ```
- Can be run with no arguments to open a REPL interface.

Has implementation-specific info at the top of its source file.

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

Some interpreters can do more than that, but each can do at least that. Implementation-specific
information and instructions on how to run an interpreter can be found at the top of its source file.

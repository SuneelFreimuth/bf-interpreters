import sys

BRAINFUCK = (
'''########  ########     ###    #### ##    ## ######## ##     ##  ######  ##    ## 
##     ## ##     ##   ## ##    ##  ###   ## ##       ##     ## ##    ## ##   ##  
##     ## ##     ##  ##   ##   ##  ####  ## ##       ##     ## ##       ##  ##   
########  ########  ##     ##  ##  ## ## ## ######   ##     ## ##       #####    
##     ## ##   ##   #########  ##  ##  #### ##       ##     ## ##       ##  ##   
##     ## ##    ##  ##     ##  ##  ##   ### ##       ##     ## ##    ## ##   ##  
########  ##     ## ##     ## #### ##    ## ##        #######   ######  ##    ##'''
)

MAGENTA = '\u001b[35m' 
YELLOW  = '\u001b[33m' 
CLEAR   = '\u001b[0m' 

SEMANTICS = (
f'''Command descriptions from https://esolangs.org/wiki/brainfuck
  {YELLOW}>{CLEAR}  Move the pointer to the right
  {YELLOW}<{CLEAR}  Move the pointer to the left
  {YELLOW}+{CLEAR}  Increment the memory cell at the pointer
  {YELLOW}-{CLEAR}  Decrement the memory cell at the pointer
  {YELLOW}.{CLEAR}  Output the character signified by the cell at the pointer
  {YELLOW},{CLEAR}  Input a character and store it in the cell at the pointer
  {YELLOW}[{CLEAR}  Jump past the matching ] if the cell at the pointer is 0
  {YELLOW}]{CLEAR}  Jump back to the matching [ if the cell at the pointer is nonzero'''
)

class NoInputProvided(Exception):
    pass

def interpret(code, tape_length=30000):
    tape = [0] * tape_length
    pdata = 0
    pinst = 0
    while pinst < len(code):
        inst = code[pinst]
        if inst == '>':
            pdata += 1
        elif inst == '<':
            if pdata > 0:
                pdata -= 1
        elif inst == '+':
            tape[pdata] += 1
        elif inst == '-':
            tape[pdata] -= 1
        elif inst == '.':
            print(chr(tape[pdata]), end='')
        elif inst == ',':
            inp = input('Input>').strip()
            if len(inp) > 0:
                tape[pdata] = inp.encode()[0]
            else:
                raise NoInputProvided()
        elif inst == '[':
            if tape[pdata] == 0:
                bracket_stack = 0
                while True:
                    pinst += 1
                    if code[pinst] == '[':
                        bracket_stack += 1
                    elif code[pinst] == ']' and bracket_stack > 0:
                        bracket_stack -= 1
                    elif code[pinst] == ']' and bracket_stack == 0:
                        pinst += 1
                        break
        elif inst == ']':
            if tape[pdata] != 0:
                bracket_stack = 0
                while True:
                    pinst -= 1
                    if code[pinst] == ']':
                        bracket_stack += 1
                    elif code[pinst] == '[' and bracket_stack > 0:
                        bracket_stack -= 1
                    elif code[pinst] == '[' and bracket_stack == 0:
                        break
        pinst += 1

def run_code(code):
    try:
        interpret(code)
        print()
    except NoInputProvided:
        print('Error: No input was provided.')

if len(sys.argv) == 1:
    while True:
        try:
            inp = input('> ')
        except (EOFError, KeyboardInterrupt):
            break
        if len(inp) == 0:
            continue
        elif inp[0] == '!':
            command, *args = inp[1:].split()
            if command == 'quit' or command == 'exit':
                break
            elif command == 'load':
                try:
                    with open(args[0]) as f:
                        run_code(f.read())
                except FileNotFoundError:
                    print(f'Could not find file "{args[0]}"')
            elif command == 'semantics':
                print(SEMANTICS)
            elif command == 'help':
                print(
                    MAGENTA + BRAINFUCK + CLEAR + '\n'
                    'Commands:\n' +
                    f'  {YELLOW}!quit{CLEAR}  Quit the interpreter.\n' +
                    f'  {YELLOW}!load{CLEAR}  Load and run Brainfuck code from a file.\n' +
                    f'  {YELLOW}!semantics{CLEAR}  List of Brainfuck commands.'
                )
            else:
                print(f'Unknown command "{command}"; run "!help" for a list of available commands.')
        else:
            run_code(inp)
elif len(sys.argv) == 2:
    arg = sys.argv[1]
    if arg == '-h' or arg == '--help':
        print(
'''Usage: python bf.py [code]
  Runs code if provided, otherwise enters a REPL.'''
        )
    else:
        interpret(arg)
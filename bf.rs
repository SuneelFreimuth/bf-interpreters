/* Language: Rust
 * Run with
 *   rustc bf.rs
 *   ./bf
 */

use std::io::Write;
use std::env;

const TAPE_LEN: usize = 30_000;

fn interpret(stdin: &std::io::Stdin, stdout: &mut std::io::Stdout, code: &Vec<u8>) {
    let mut tape: [u8; TAPE_LEN] = [0; TAPE_LEN];
    let mut pdata: usize = 0;
    let mut pinst: usize = 0;
    while pinst < code.len() {
        match code[pinst] as char {
            '>' => {
                if pdata < TAPE_LEN - 1 {
                    pdata += 1;
                }
            },
            '<' => {
                if pdata > 0 {
                    pdata -= 1;
                }
            },
            '+' => {
                if tape[pdata] < 255 {
                    tape[pdata] += 1;
                }
            },
            '-' => {
                if tape[pdata] > 0 {
                    tape[pdata] -= 1;
                }
            },
            '.' => {
                stdout.write(&tape[pdata..pdata+1]).expect("wut");
            },
            ',' => {
                print!("Input>");
                let mut input = String::new();
                stdin.read_line(&mut input).expect("wut");
                tape[pdata] = input.as_bytes()[0];
            },
            '[' => {
                if tape[pdata] == 0 {
                    let mut bracket_stack: u32 = 0;
                    while pinst < code.len() {
                        pinst += 1;
                        if code[pinst] as char == '[' {
                            bracket_stack += 1;
                        } else if code[pinst] as char == ']' && bracket_stack > 0 {
                            bracket_stack -= 1;
                        } else if code[pinst] as char == ']' && bracket_stack == 0 {
                            pinst += 1;
                            break;
                        }
                    }
                }
            },
            ']' => {
                if tape[pdata] != 0 {
                    let mut bracket_stack: u32 = 0;
                    while pinst > 0 {
                        pinst -= 1;
                        if code[pinst] as char == ']' {
                            bracket_stack += 1;
                        } else if code[pinst] as char == '[' && bracket_stack > 0 {
                            bracket_stack -= 1;
                        } else if code[pinst] as char == '[' && bracket_stack == 0 {
                            break;
                        }
                    }
                }
            },
            _ => {}
        }
        pinst += 1;
    }
    stdout.write(b"\n").expect("wut");
}


fn main() {
    let args: Vec<String> = env::args().collect();
    let stdin = std::io::stdin();
    let mut stdout = std::io::stdout();
    if args.len() > 1 {
        interpret(&stdin, &mut stdout, &args[1].clone().into_bytes());
    } else {
        loop {
            stdout.write(b">").expect("wut");
            stdout.flush().expect("wut");
            let mut input = String::new();
            stdin.read_line(&mut input).expect("wut");
            interpret(&stdin, &mut stdout, &input.into_bytes());
        }
    }
}

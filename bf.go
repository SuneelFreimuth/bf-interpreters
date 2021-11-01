package main

import (
	"fmt"
	"os"
)

func interpret(code string) {
	tape := [3e5]byte{}
	pinst := 0
	pdata := 0
	for pinst < len(code) {
		switch code[pinst] {
		case '>':
			if pdata < len(tape)-1 {
				pdata += 1
			}
		case '<':
			if pdata > 0 {
				pdata -= 1
			}
		case '+':
			if tape[pdata] < 255 {
				tape[pdata] += 1
			}
		case '-':
			if tape[pdata] > 0 {
				tape[pdata] -= 1
			}
		case '.':
			fmt.Printf("%c", tape[pdata])
		case ',':
			fmt.Print("Input>")
			var input string
			n, err := fmt.Scanln(&input)
			if err != nil {
				fmt.Print(n, err)
			} else {
				tape[pdata] = input[0]
			}
		case '[':
			if tape[pdata] == 0 {
				var bracketStack uint32 = 0
				for {
					pinst += 1
					if code[pinst] == '[' {
						bracketStack += 1
					} else if code[pinst] == ']' && bracketStack > 0 {
						bracketStack -= 1
					} else if code[pinst] == ']' && bracketStack == 0 {
						pinst += 1
						break
					}
				}
			}
		case ']':
			if tape[pdata] != 0 {
				var bracketStack uint32 = 0
				for {
					pinst -= 1
					if code[pinst] == ']' {
						bracketStack += 1
					} else if code[pinst] == '[' && bracketStack > 0 {
						bracketStack -= 1
					} else if code[pinst] == '[' && bracketStack == 0 {
						break
					}
				}
			}
		}
		pinst += 1
	}
}

func main() {
	if len(os.Args) > 1 {
		interpret(os.Args[1])
	} else {
		for {
			fmt.Print(">")
			var input string
			n, err := fmt.Scanln(&input)
			if err != nil {
				fmt.Print(n, err)
				continue
			}
			interpret(input)
		}
	}
}

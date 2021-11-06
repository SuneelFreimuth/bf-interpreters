/* Language: C++
 * Run like
 *   g++ -o bf bf.cpp
 *   ./bf
 */

#include <iostream>
#include <string>
#include <array>
#include <fstream>

using u32 = unsigned int;
using byte = unsigned char;

const u32 TAPE_LEN = 3e4;

void interpret(const std::string& code) {
    std::array<byte, TAPE_LEN> tape;
    tape.fill(0);
    u32 pdata = 0;
    u32 pinst = 0;
    while (pinst < code.length()) {
        switch (code[pinst]) {
            case '>':
                if (pdata < TAPE_LEN - 1) pdata++;
                break;
            case '<':
                if (pdata > 0) pdata--;
                break;
            case '+':
                if (tape[pdata] < 255)
                    tape[pdata] = tape[pdata] + 1;
                break;
            case '-':
                if (tape[pdata] > 0)
                    tape[pdata] = tape[pdata] - 1;
                break;
            case '.':
                std::cout << tape[pdata];
                break;
            case ',':
                std::cout << "Input>";
                std::cin >> tape[pdata];
                break;
            case '[':
                if (tape[pdata] == 0) {
                    u32 bracket_stack = 0;
                    while (pinst < code.length()) {
                        pinst++;
                        if (code[pinst] == '[')
                            bracket_stack++;
                        else if (code[pinst] == ']' && bracket_stack > 0)
                            bracket_stack--;
                        else if (code[pinst] == ']' && bracket_stack == 0) {
                            pinst++;
                            break;
                        }
                    }
                }
                break;
            case ']':
                if (tape[pdata] != 0) {
                    u32 bracket_stack = 0;
                    while (pinst > 0) {
                        pinst--;
                        if (code[pinst] == ']')
                            bracket_stack++;
                        else if (code[pinst] == '[' && bracket_stack > 0)
                            bracket_stack--;
                        else if (code[pinst] == '[' && bracket_stack == 0)
                            break;
                    }
                }
                break;
        }
        pinst++;
    }
    std::cout << std::endl;
}

int main(int argc, char** argv) {
    if (argc > 1)
        interpret(argv[1]);
    else {
        while (true) {
            putchar('>');
            std::string input;
            std::getline(std::cin, input);
            interpret(std::move(input));
        }
    }
    return 0;
}

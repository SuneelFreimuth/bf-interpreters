#include "stdio.h"
#include "string.h"
#include "stdbool.h"

typedef unsigned char byte;
typedef unsigned int u32;

const u32 TAPE_LEN = 3e4;

void interpret(const char* code) {
    byte tape[TAPE_LEN];
    for (u32 i = 0; i < TAPE_LEN; i++) tape[i] = 0;
    u32 pdata = 0;
    u32 pinst = 0;
    size_t code_len = strlen(code);
    while (pinst < code_len) {
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
                putchar(tape[pdata]);
                break;
            case ',':
                printf("Input>");
                tape[pdata] = getchar();
                break;
            case '[':
                if (tape[pdata] == 0) {
                    u32 bracket_stack = 0;
                    while (pinst < code_len) {
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
    putchar('\n');
}

int main(int argc, char** argv) {
    if (argc > 1)
        interpret(argv[1]);
    else {
        while (true) {
            putchar('>');
            char input[1024];
            char* p = fgets(input, 1024, stdin);
            if (p == NULL) break;
            interpret(input);
        }
    }
    return 0;
}

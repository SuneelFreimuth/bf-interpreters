/* Language: C
 * Run like
 *   gcc -o bf bf.c
 *   ./bf
 */

import java.util.Scanner;

public class BF {
    public static final int TAPE_LEN = 30_000;

    static void interpret(String code, Scanner in) {
        byte[] tape = new byte[TAPE_LEN];
        int pdata = 0;
        int pinst = 0;
        while (pinst < code.length()) {
            switch (code.charAt(pinst)) {
                case '>':
                    if (pdata < TAPE_LEN - 1) pdata++;
                    break;
                case '<':
                    if (pdata > 0) pdata--;
                    break;
                case '+':
                    if (tape[pdata] < 255)
                        tape[pdata]++;
                    break;
                case '-':
                    if (tape[pdata] > 0)
                        tape[pdata]--;
                    break;
                case '.':
                    System.out.print((char) tape[pdata]);
                    break;
                case ',':
                    System.out.print("Input>");
                    tape[pdata] = (byte) in.next().charAt(0);
                    break;
                case '[':
                    if (tape[pdata] == 0) {
                        int bracket_stack = 0;
                        while (pinst < code.length()) {
                            pinst++;
                            if (code.charAt(pinst) == '[')
                                bracket_stack++;
                            else if (code.charAt(pinst) == ']' && bracket_stack > 0)
                                bracket_stack--;
                            else if (code.charAt(pinst) == ']' && bracket_stack == 0) {
                                pinst++;
                                break;
                            }
                        }
                    }
                    break;
                case ']':
                    if (tape[pdata] != 0) {
                        int bracket_stack = 0;
                        while (pinst > 0) {
                            pinst--;
                            if (code.charAt(pinst) == ']')
                                bracket_stack++;
                            else if (code.charAt(pinst) == '[' && bracket_stack > 0)
                                bracket_stack--;
                            else if (code.charAt(pinst) == '[' && bracket_stack == 0)
                                break;
                        }
                    }
                    break;
            }
            pinst++;
        }
        System.out.print('\n');
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        if (args.length > 1)
            BF.interpret(args[1], sc);
        else {
            while (true) {
                System.out.print('>');
                BF.interpret(sc.nextLine(), sc);
            }
        }
    }
}

// Language: Zig
// I recommend building an executable and running it like
//   ```
//   zig build-exe bf.zig
//   bf
//   ```
// so that you can pass the executable command line arguments.
// Compatible with Zig v8.x and v9.x.

const std = @import("std");
const process = std.process;
const Allocator = std.mem.Allocator;

fn interpret(code: []const u8, tape: []u8) []u8 {
    var pdata: u32 = 0;
    var pinst: u32 = 0;
    while (pinst < code.len) {
        var inst = code[pinst];
        switch (inst) {
            '>' => {
                if (pdata < tape.len - 1) pdata += 1;
            },
            '<' => {
                if (pdata > 0) pdata -= 1;
            },
            '+' => {
                if (tape[pdata] < @bitSizeOf(u8) - 1) tape[pdata] += 1;
            },
            '-' => {
                if (tape[pdata] > 0) tape[pdata] -= 1;
            },
            '[' => {
                if (tape[pdata] == 0) {
                    @setEvalBranchQuota(10_000);
                    var bracket_stack: u32 = 0;
                    while (pinst < code.len) {
                        pinst += 1;
                        if (code[pinst] == '[') {
                            bracket_stack += 1;
                        } else if (code[pinst] == ']' and bracket_stack > 0) {
                            bracket_stack -= 1;
                        } else if (code[pinst] == ']' and bracket_stack == 0) {
                            pinst += 1;
                            break;
                        }
                    }
                }
            },
            ']' => {
                if (tape[pdata] > 0) {
                    @setEvalBranchQuota(10_000);
                    var bracket_stack: u32 = 0;
                    while (pinst > 0) {
                        pinst -= 1;
                        if (code[pinst] == ']') {
                            bracket_stack += 1;
                        } else if (code[pinst] == '[' and bracket_stack > 0) {
                            bracket_stack -= 1;
                        } else if (code[pinst] == '[' and bracket_stack == 0) {
                            break;
                        }
                    }
                }
            },
            else => {},
        }
        pinst += 1;
    }
    return tape[0 .. pdata + 1];
}

const HELLO_WORLD = "++++++++[>++++[>++>+++>+++>+++>+<<<<<-]>+>+>->+++>>+[<]<-]>>.>---.+++++++..+++.>>>.<<-.<.>>------.<<---.--------.>>>+.-.<<---.<++++.+.>>+.>.<<<<+.>>>.>.<<<<---.>.>>.<<-.>>+++++++...>+.>++.";

const result = comptime {
    var tape = [_]u8{0} ** 30_000;
    return interpret(HELLO_WORLD, tape[0..]);
};

pub fn main() void {
    @compileLog(result);
    var stdout = std.io.getStdOut().writer();
    _ = stdout.write(result) catch unreachable;
}

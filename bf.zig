// Language: Zig
// Run with the Zig compiler like `zig run bf.zig`;
// compatible with v8.x and v9.x.

const std = @import("std");
const process = std.process;
const Allocator = std.mem.Allocator;
const print = std.debug.print;
const mem = std.mem;

fn interpret(stdin: anytype, stdout: anytype, code: []const u8) !void {
    var tape = [_]u8{0} ** 30_000;
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
                tape[pdata] += 1;
            },
            '-' => {
                tape[pdata] -%= 1;
            },
            '.' => {
                try stdout.writeByte(tape[pdata]);
            },
            ',' => {
                _ = try stdout.write("Input>");
                tape[pdata] = stdin.readByte() catch tape[pdata];
            },
            '[' => {
                if (tape[pdata] == 0) {
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
}

const program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.";

fn readLine(stdin: anytype, buffer: []u8) []u8 {
    return stdin.readUntilDelimiterOrEof(buffer, '\n') catch buffer orelse buffer;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var alloc = &gpa.allocator;
    const args = try process.argsAlloc(alloc);
    const stdin  = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    if (args.len > 1) {
        try interpret(stdin, stdout, args[1]);
    } else {
        while (true) {
            try stdout.writeByte('>');
            var buffer: [1024]u8 = undefined;
            const data = readLine(stdin, buffer[0..]);
            if (data.len == 0) continue;
            if (mem.eql(u8, data, "quit")) {
                break;
            } else {
                try interpret(stdin, stdout, data);
            }
            try stdout.writeByte('\n');
        }
    }
}

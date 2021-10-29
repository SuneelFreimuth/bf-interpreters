// Author: Suneel Freimuth
// Run with Node. Tested with Node 10 as the earliest version.

const readline = require("readline");
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})

class NoInputProvided extends Error {
    constructor(...args) {
        super(...args)
    }
}

const input = prompt => new Promise(resolve => {
    rl.question(prompt, resolve)
})

async function interpret(code, tape_length=30000) {
    const tape = Array(tape_length).fill(0)
    let pdata = 0
    let pinst = 0
    while (pinst < code.length) {
        const inst = code[pinst]
        switch (inst) {
            case '>':
                pdata++
                break
            case '<':
                if (pdata > 0) {
                    pdata--
                }
                break
            case '+':
                tape[pdata]++
                break
            case '-':
                tape[pdata]--
                break
            case '.':
                process.stdout.write( Buffer.from([tape[pdata]]) )
                break
            case ',':
                const inp = (await input('Input>')).trimEnd()
                if (inp.length > 0) {
                    tape[pdata] = inp.codePointAt(0) & 0xFF // Constrain to 1 byte.
                } else {
                    throw new NoInputProvided()
                }
                break
            case '[':
                if (tape[pdata] === 0) {
                    let bracket_stack = 0
                    while (true) {
                        pinst += 1
                        if (code[pinst] === '[') {
                            bracket_stack++
                        } else if (code[pinst] === ']' && bracket_stack > 0) {
                            bracket_stack--
                        } else if (code[pinst] === ']' && bracket_stack === 0) {
                            pinst++
                            break
                        }
                    }
                }
                break
            case ']':
                if (tape[pdata] !== 0) {
                    let bracket_stack = 0
                    while (true) {
                        pinst--
                        if (code[pinst] === ']')
                            bracket_stack++
                        else if (code[pinst] === '[' && bracket_stack > 0)
                            bracket_stack--
                        else if (code[pinst] === '[' && bracket_stack === 0)
                            break
                    }
                }
                break
        }
        pinst++
    }
}

async function main() {
    if (process.argv.length > 2) {
        await interpret(process.argv[2])
    } else {
        while (true) {
            const inp = await input('>')
            await interpret(inp)
            console.log()
        }
    }
}

main().finally(() => {
    rl.close()
})
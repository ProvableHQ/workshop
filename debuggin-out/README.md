# Debuggin' Out

`leo debug` is a powerful tool that developers can use to interactively step through executions and track down bugs. In this workshop, we'll use the Leo debugger to explore and gain a deeper understanding a variety of programs. You will also build up the skills to adeptly use the debugger in your development work.

**This tutorial assumes that you are already familiar with Leo. If you'd like a refresher, see the [Developer Docs](https://docs.leo-lang.org/getting_started)**.

We're always looking to improve Leo's developer experience. If you have any feedback, please feel free to [file](https://github.com/ProvableHQ/leo/issues/new/choose) an issue!

# Setup

## Source Material

Install the latest version of the [workshop](https://github.com/ProvableHQ/workshop/).

## Leo

[Install](https://github.com/ProvableHQ/leo?tab=readme-ov-file#%EF%B8%8F%EF%B8%8F-build-guide) Leo. You may also use the [install script](https://github.com/ProvableHQ/workshop/blob/master/install.sh) in the workshop.

# An Introduction


First, let's fire up the debugger.
```bash
leo debug
```
You'll see this prompt pop up.
<pre>
<code>
This is the Leo Interpreter. Try the command `#help`.
? <b>Command?</b> › 
</code>
</pre>
Let's go ahead and run the `#help` command.
<pre>
<code>
✔ <b>Command?</b> · #help

You probably want to start by running a function or transition.
For instance
#into program.aleo/main()
Once a function is running, commands include
#into    to evaluate into the next expression or statement;
#step    to take one step towards evaluating the current expression or statement;
#over    to complete evaluating the current expression or statement;
#run     to finish evaluating
#quit    to quit the interpreter.

You can set a breakpoint with
#break program_name line_number

When executing Aleo VM code, you can print the value of a register like this:
#print 2

Some of the commands may be run with one letter abbreviations, such as #i.

Note that this interpreter is not line oriented as in many common debuggers;
rather it is oriented around expressions and statements.
As you step into code, individual expressions or statements will
be evaluated one by one, including arguments of function calls.

You may simply enter Leo expressions or statements on the command line
to evaluate. For instance, if you want to see the value of a variable w:
w
If you want to set w to a new value:
w = z + 2u8;

Note that statements (like the assignment above) must end with a semicolon.

If there are futures available to be executed, they will be listed by
numerical index, and you may run them using `#future` (or `#f`); for instance
#future 0

The interpreter begins in a global context, not in any Leo program. You can set
the current program with

#set_program program_name

This allows you to refer to structs and other items in the indicated program.

The interpreter may enter an invalid state, often due to Leo code entered at the
REPL. In this case, you may use the command

#restore

Which will restore to the last saved state of the interpreter. Any time you
enter Leo code at the prompt, interpreter state is saved.

Input history is available - use the up and down arrow keys.
</code>
</pre>

The `leo debug` initializes a REPL loop in which you may run standalone Leo code.

<pre>
<code>
✔ <b>Command?</b> · 1u32 + 2u32
Result: 3u32

✔ <b>Command?</b> · let x: u32 = 1u32;
✔ <b>Command?</b> · let y: u32 = 2u32;
✔ <b>Command?</b> · let z: u32 = x + y;
✔ <b>Command?</b> · x
Result: 1u32

✔ <b>Command?</b> · y
Result: 2u32

✔ <b>Command?</b> · z
Result: 3u32
</code>
</pre>


More often than not, you'll be using the debugger to step through a program. Let's see how that works.

First, let's go to the program under investigation. In the directory where you installed the source material, run
```bash
cd workshop/learn_to_debug/point_math
leo debug
```
The debugger will type check the `point_math.aleo` and initialize a REPL loop with access to the program definition. In additional to directly evaluating Leo code, the debugger provides commands with which the user can selectively step through code:
* `#into | #i` - to evaluate **into** the next expression or statement
* `#step | #s` - to take one step towards evaluating the current expression or statement
* `#over | #o` - to complete evaluating the current expression or statement
* `#run | #r` -  to finish evaluating
* `#break | #b <PROGRAM_NAME> <LINE_NUMBER>` - to set a breakpoint
* `#watch` | `#w <EXPRESSION>` - to watch an expression. It's value will be printed out each step of the interpreter.


`#into` is particularly useful as users can prefix a Leo statement or expression with an `#into` command to step through the associated code. We'll now use the debugger to step through an evaluation of the `sqrt_bitwise` function.


<pre>
<code>
✔ <b>Command?</b> · #i point_math.aleo/sqrt_bitwise(0u32)
Prepared to evaluate:
<b>point_math.aleo/sqrt_bitwise(0u32)</b>

✔ <b>Command?</b> · #i
Prepared to evaluate:
point_math.aleo/sqrt_bitwise(<b>0u32</b>)

✔ <b>Command?</b> · #s
Result: 0u32

Prepared to evaluate:
<b>point_math.aleo/sqrt_bitwise(0u32)</b>

✔ <b>Command?</b> · #s
Prepared to evaluate:
<b>point_math.aleo/sqrt_bitwise(0u32)</b>

✔ <b>Command?</b> · #s
Result: 0u32
</code>
</pre>


## Challenge

1. Use the above commands to step through evaluations of `sqrt_bitwise` for inputs `0u32`, `1u32`, `4u32`, `9u32`. Are they as you expect?

2. Use the debugger and the above commands to:
   a. Create and store two distinct `Point` records.
   b. Calculate the distance between them.
   c. Add the points together.

## Solution

Transcripts for each of the above challenges are given below.

### Part 1
<pre>
<code>
✔ <b>Command?</b> · #i point_math.aleo/sqrt_bitwise(0u32)
Prepared to evaluate:
point_math.aleo/sqrt_bitwise(0u32)

✔ <b>Command?</b> · #o
Result: 0u32

✔ <b>Command?</b> · #i point_math.aleo/sqrt_bitwise(1u32)
Prepared to evaluate:
point_math.aleo/sqrt_bitwise(1u32)

✔ <b>Command?</b> · #o
Result: 1u32

✔ <b>Command?</b> · #i point_math.aleo/sqrt_bitwise(4u32)
Prepared to evaluate:
point_math.aleo/sqrt_bitwise(4u32)

✔ <b>Command?</b> · #o
Result: 2u32

✔ <b>Command?</b> · #i point_math.aleo/sqrt_bitwise(9u32)
Prepared to evaluate:
point_math.aleo/sqrt_bitwise(9u32)

✔ <b>Command?</b> · #o
Result: 3u32
</code>
</pre>


### Part 2

<pre>
<code>
✔ <b>Command?</b> · let p1: Point = point_math.aleo/create_point(1u32, 2u32);
✔ <b>Command?</b> · let p2: Point = point_math.aleo/create_point(3u32, 4u32);
✔ <b>Command?</b> · p1
Result: Point {owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px, x: 1u32, y: 2u32}

✔ <b>Command?</b> · p2
Result: Point {owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px, x: 3u32, y: 4u32}

✔ <b>Command?</b> · let distance: u32 = point_math.aleo/distance(p1, p2);
✔ Command? · distance
Result: 2u32

✔ <b>Command?</b> · let sum: Point = point_math.aleo/add_points(p1, p2);
✔ <b>Command?</b> · sum
Result: Point {owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px, x: 4u32, y: 6u32}
</code>
</pre>

# Pro Tips

The Leo debugger also provides a number of features to help with more advanced debugging. These will be helpful as you go through the more complex examples below.

## Recovering From Errors

As you step through and evaluate code, you may run into a state where your debugger halts. This can happen for a number of reasons including, accessing values that don't exist, attempting to evaluate expressions that overflow, etc. If this happens, the `#restore` command can help you recover the debugger to the last code point.

## Setting a Namespace

The Leo debugger initializes in a "global" context, which contains the programs and dependencies in your project. When you invoke a transition or function, the debugger implicitly steps into the associated program's scope.

You may find youself wanting to initialize structs and records defined in a specific program. To do so, you can explicitly set the program scope and directly instantiate data types.

By setting a program scope, you can also directly invoke functions and interact with mappings defined in that scope. This is useful as specifying the full path (program name and resource) can be cumbersome.
<pre>
<code>
✔ <b>Command?</b> · #set_program point_math

✔ <b>Command?</b> · let p: Point = Point { owner: self.caller, x: 1u32, y: 2u32 };

✔ <b>Command?</b> · p
Result: Point {owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px, x: 1u32, y: 2u32}

✔ <b>Command?</b> · let a: u32 = sqrt_bitwise(0u32);

✔ <b>Command?</b> · a
Result: 0u32
</code>
</pre>

## Cheatcodes

The debugger also provides users with a number of "cheatcodes" to aid in debugging. The supported cheatcodes include:
- `CheatCode::print_mapping(<MAPPING>)`
- `CheatCode::set_block_height(<u32>)`

## GUI

The Leo debugger also provides a user with a more sophisticated GUI, which can help step through code cleanly. The interface can be enabled with the `--tui` command and provides better code visualization, where the current line is highlighted.

<pre>
<code>
┌code──────────────────────────────────────────────────────────────────────────────────────────────────┐
│    }                                                                                                 │
│                                                                                                      │
│    // An implementation of integer square root.                                                      │
│    function sqrt_bitwise(n: u32) -> u32 {                                                            │
│        <b>let res: u32 = 0u32;</b>                                                                          │
│        // Iterate over all 32 bits from most significant to least significant                        │
│        for inv_shift: u8 in 0u8..32u8 {                                                              │
│            let shift: u8 = 31u8 - inv_shift;                                                         │
│            let bit: u32 = 1u32 << shift;                                                             │
│            let temp: u32  = res | bit;                                                               │
│            // Check if temp is safe to square without overflow                                       │
│            if temp <= 65535u32 { // √(2^32 - 1) = 65535                                              │
│                let square: u32 = temp.mul_wrapped(temp);                                             │
│                if square <= n {                                                                      │
│                    res = temp; // Update res if temp^2 <= n                                          │
│                }                                                                                     │
│            }                                                                                         │
│        }                                                                                             │
│        return res;                                                                                   │
│    }                                                                                                 │
│                                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌Result────────────────────────────────────────────┐┌Watchpoints───────────────────────────────────────┐
│0u32                                              ││                                                  │
│                                                  ││                                                  │
│                                                  ││                                                  │
│                                                  ││                                                  │
└──────────────────────────────────────────────────┘└──────────────────────────────────────────────────┘
┌Message───────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌Command:──────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                      │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
</code>
</pre>

# A More Complicated Example
In the previous example, we use `leo debug` to evaluate simple transitions with strictly off-chain execution. The debugger can also be used to evaluate on-chain code.

Let's dive in further by looking at some code. First let's navigate to the code and fire up the debugger.
```bash
cd workshop/learn_to_debug/access_control
leo debug
```

Using the debugger, a user can directly produce and evaluate futures. Users can also interact with mappings by directly executing Leo code.

<pre>
<code>
✔ <b>Command?</b> · #set_program access_control

✔ <b>Command?</b> · let f: Future = set_timelock(self.caller, 1u32);

✔ <b>Command?</b> · f.await()
Result: ()

✔ <b>Command?</b> · CheatCode::print_mapping(timelocks)
Mapping: timelocks
  Metadata {locker: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px, lockee: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px} -> 1u32
Result: ()

✔ <b>Command?</b> · let m: Metadata = Metadata { locker: self.caller, lockee: self.caller };

✔ <b>Command?</b> · timelocks.get(m)
Result: 1u32

✔ <b>Command?</b> · timelocks.set(m, 2u32);

✔ <b>Command?</b> · timelocks.get(m)
Result: 2u32
</code>
</pre>

## Challenge

Navigate to the `timelocked_credits` example and fire up the debugger.

```bash
cd workshop/learn_to_debug/timelocked_credits
leo debug
```


1. Deposit `10` credits. Note that you'll need to set the state of the `account` mapping in `credits.aleo`.
2. Increment the block height by 1 and attempt to withdraw.
3. Increment the block height by 3 and withdraw.

While you are stepping through the code, be sure to the use the `#i` and `#s` commands to visualize the flow of the execution.



# Debugging AVM Bytecode

You may also use the Leo debugger to step through AVM bytecode. This can be useful for debugging programs that may be deployed on-chain, but whose Leo source code is not available.

The debugger provides the `#print | #p <REGISTER_NUMBER>` command to display register values.

## Challenge

1. Go to the Provable Explorer and pick out a program. Note that this program needs to be deployed on the same network that you have configured in your `.env` file. You can always default to `credits.aleo`.

2. Add the program as a dev dependency via `leo add`.

3. Step through an execution of the program.


# Wrapping it Up

In this tutorial, you learned how to use the Leo debugger. If you made it through all of the challenges you will have:
- Stepped through simple, local evaluations of a program.
- Simulated on-chain state to test more complex behaviors.
- Explicitly evaluated futures, giving you a better understanding of the async programming model.
- Debugged a deployed program that you may not have written directly.

We hope that this tool makes your Leo development experience easier! If you have any feedback or run into any issues, please feel free to file an issue [here](https://github.com/ProvableHQ/leo/issues/new/choose) on the Leo repo.




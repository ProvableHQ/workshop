<!-- # ⭕ Tic-Tac-Toe -->
<img alt="workshop/tictactoe" width="1412" src="../.resources/tictactoe.png">

## Summary

We can play a standard game of Tic-Tac-Toe in Leo.

⭕ ❕ ⭕ ❕ ❌

➖ ➕ ➖ ➕ ➖

⭕ ❕ ⁣❌ ❕ ⭕

➖ ➕ ➖ ➕ ➖

❌ ❕ ❌ ❕ ⭕

## Representing State
Leo allows users to define composite data types with the `struct` keyword. 
The game board is represented by a struct called `Board`, which contains three `Row`s. An alternative representation would be to use an array, however, these are not yet supported in Leo.

## Language Features
- `struct` declarations
- conditional statements
- early termination. Leo allows users to return from a function early using the `return` keyword.

## How to Run

Follow the [Leo Installation Instructions](https://developer.aleo.org/leo/installation).

This tictactoe program can be run using the following bash script. Locally, it will execute Leo program functions to create and play a game of Tic Tac Toe.

```bash
cd tictactoe
./run.sh
```

## Walkthrough

* [Step 0: Create a new board.](#step0)
* [Step 1: Player 1 makes the first move.](#step1)
* [Step 2: Player 2 makes the second move.](#step2)
* [Step 3: Player 1 makes the third move.](#step3)
* [Step 4: and so on...](#step4)

## <a id="step0"></a> Create a new board.

We generate the board, and then the player take turns executing the transition function make_move.

The inputs to the function are the player number, row position, column position, and the previous state of the board.

The output provided is the new state of the board and an evaluation of who won the game. 0u8 as the evaluation output means a draw if the board is complete or that the game is not yet over.

```bash
leo run new
```
## <a id="step1"></a> Player 1 makes a move.

Have Player 1 make the first move.

```bash
leo run make_move 1u8 1u8 1u8 "{ r1: { c1: 0u8, c2: 0u8, c3: 0u8 }, r2: { c1: 0u8, c2: 0u8, c3: 0u8 }, r3: { c1: 0u8, c2: 0u8, c3: 0u8 } }"
```

## <a id="step2"></a> Player 2 makes a move.

Have Player 2 make the second move.

```bash
leo run make_move 2u8 2u8 2u8 "{ r1: { c1: 1u8, c2: 0u8, c3: 0u8 }, r2: { c1: 0u8, c2: 0u8, c3: 0u8 }, r3: { c1: 0u8, c2: 0u8, c3: 0u8 } }"
```

## <a id="step3"></a> Player 1 makes a move.

Have Player 1 make the third move.

```bash
leo run make_move 1u8 3u8 1u8 "{ r1: { c1: 1u8, c2: 0u8, c3: 0u8 }, r2: { c1: 0u8, c2: 2u8, c3: 0u8 }, r3: { c1: 0u8, c2: 0u8, c3: 0u8 } }"
```

## <a id="step4"></a> and so on...

If you follow the run script till the end, you'll see the players make a draw, with an output of `0u64`.


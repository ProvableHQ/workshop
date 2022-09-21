#!/bin/bash
# A script to check that all examples compile and run.
# Run this script from the root directory of the workshop repository.

# Run the auction example.
cd auction
echo "


[CHECK] CHECKING THE AUCTION EXAMPLE"
chmod +x ./run.sh
./run.sh
cd ..

# Run the broken bank example.
cd broken_bank
echo "


[CHECK] CHECKING THE BROKEN BANK EXAMPLE"
chmod +x ./run.sh
./run.sh
cd ..

# Run the tictactoe example.
cd tictactoe
echo "


[CHECK] CHECKING THE TICTACTOE EXAMPLE"
chmod +x ./run.sh
./run.sh
cd ..

# Run the vote example.
cd vote
echo "


[CHECK] CHECKING THE VOTE EXAMPLE"
chmod +x ./run.sh
./run.sh
cd ..

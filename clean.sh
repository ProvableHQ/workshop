#!/bin/bash
# A script to clean all examples.
# Run this script from the root directory of the workshop repository.

# Clean the auction example.
cd auction
leo clean
cd ..

# Clean the basic bank example.
cd basic_bank
leo clean
cd ..

# Clean the battleship example.
cd battleship
leo clean
cd ..

# Clean the tictactoe example.
cd tictactoe
leo clean
cd ..

# Clean the token example.
cd token
leo clean
cd ..

# Clean the vote example.
cd vote
leo clean
cd ..

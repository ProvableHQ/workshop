#!/bin/bash
# A script to check that all examples compile and run.
# Run this script from the root directory of the workshop repository.

# Run the auction example.
cd auction
echo "[CHECK] CHECKING THE AUCTION EXAMPLE"
chmod +x ./run.sh
./run.sh
cd ..

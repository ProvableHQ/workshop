#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We will be playing the role of three parties.

The private key and address of the first bidder.
private_key: APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
address: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px

The private key and address of the second bidder.
private_key: APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
address: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t

The private key and address of the auctioneer.
private_key: APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
address: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg
"

echo "
Let's start an auction!

###############################################################################
########                                                               ########
########           Step 0: Initialize a new 2-party auction            ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |         |         |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Let's take the role of the first bidder - we'll swap in the private key and address of the first bidder to .env.

We're going to run the transition function "place_bid", slotting in the first bidder's public address and the amount that is being bid. The inputs are the user's public address and the amount being bid.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
' > .env

leo run place_bid aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 10u64
"

# Swap in the private key of the first bidder to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
" > .env

# Have the first bidder place a bid of 10.
leo run place_bid aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 10u64

echo "
###############################################################################
########                                                               ########
########         Step 1: The first bidder places a bid of 10           ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |         |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Now we're going to place another bid as the second bidder, so let's switch our keys to the second bidder and run the same transition function, this time with the second bidder's keys, public address, and different amount.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
' > .env

leo run place_bid aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 90u64
"

# Swap in the private key of the second bidder to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
" > .env

# Have the second bidder place a bid of 90.
leo run place_bid aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 90u64

echo "
###############################################################################
########                                                               ########
########          Step 2: The second bidder places a bid of 90         ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |   90    |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Now, let's take the role of the auctioneer, so we can determine which bid wins. Let's swap our keys to the auctioneer and run the resolve command on the output of the two bids from before. The resolve command takes the two output records from the bids as inputs and compares them to determine which bid wins.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
' > .env

leo run resolve '{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
    }' '{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }'
"

# Swaps in the private key of the auctioneer to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
" > .env

# Have the auctioneer select the winning bid.
leo run resolve "{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
    }" "{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

echo "
###############################################################################
########                                                               ########
########     Step 3: The auctioneer determines the winning bidder      ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |  → B ←  |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |  → 90 ← |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Keeping the key environment the same since we're still the auctioneer, let's finalize the auction and label the winning output as the winner. The finish transition takes the winning output bid as the input and marks it as such.

leo run finish '{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }'
"

# Have the auctioneer finish the auction.
leo run finish "{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

echo "
###############################################################################
########                                                               ########
########              The auctioneer completes the auction.            ########
########                                                               ########
########                -------------------------------                ########
########                |  CLOSE  |    A    |  → B ←  |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |  → 90 ← |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

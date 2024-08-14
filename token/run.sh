#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We'll be conducting a transfer between two parties.

The private key and address of Alice.
private_key: APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
address: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px

The private key and address of Bob.
private_key: APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
address: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t
"

echo "
Let's play Alice. Swap in her private key and publicly mint 100 tokens.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run mint_public aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 100u64
"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run mint_public aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 100u64

echo "
You can see the output of the finalize function of mint_public, which takes the arguments Alice's address and the amount of tokens to mint publicly. This information is shown on-chain and can be queried on a network.

###############################################################################
########                                                               ########
########     STEP 0: Publicly mint 100 tokens for Alice                ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PUBLIC BALANCES            |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |         100         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          0          |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PRIVATE BALANCES           |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          0          |           ########
########           -----------------------------------------           ########
########           |        Bob      |          0          |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Now let's privately mint 100 tokens for Bob. Switch to Bob's private key and privately mint 100 tokens for Bob.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run mint_private aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 100u64
"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run mint_private aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 100u64

echo "
The output is a private record.

###############################################################################
########                                                               ########
########     STEP 1: Privately mint 100 tokens for Bob                 ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PUBLIC BALANCES            |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |         100         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          0          |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PRIVATE BALANCES           |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          0          |           ########
########           -----------------------------------------           ########
########           |        Bob      |         100         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Let's publicly transfer 10 tokens from Alice to Bob. Swap the private key back to Alice and call the public transfer transition.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run transfer_public aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 10u64
" 

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run transfer_public aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 10u64

echo "
Again, we see the arguments used for the finzalize function of transfer_public - Alice's address, Bob's address, and the amount to transfer. The public mapping will be queryable on-chain.

###############################################################################
########                                                               ########
########     STEP 2: Publicly transfer 10 tokens from Alice to Bob     ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PUBLIC BALANCES            |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          90         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          10         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PRIVATE BALANCES           |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          0          |           ########
########           -----------------------------------------           ########
########           |        Bob      |         100         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Let's privately transfer 20 tokens from Bob to Alice. Switch to Bob's private key and call the private transfer transition.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run transfer_private '{
    owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
    amount: 100u64.private,
    _nonce: 6586771265379155927089644749305420610382723873232320906747954786091923851913group.public
}' aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 20u64
"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run transfer_private "{
    owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
    amount: 100u64.private,
    _nonce: 6586771265379155927089644749305420610382723873232320906747954786091923851913group.public
}" aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 20u64

echo "
The output of transfer_private is a record owned by Bob less the 20 tokens he privately transferred to Alice, and a record owned by Alice with the 20 tokens Bob transferred to Alice.

###############################################################################
########                                                               ########
########     STEP 3: Privately transfer 20 tokens from Bob to Alice    ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PUBLIC BALANCES            |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          90         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          10         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PRIVATE BALANCES           |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          20         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          80         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Let's convert 30 of Alice's public tokens into 30 private tokens for Bob. Switch the private key back to Alice.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run transfer_public_to_private aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 30u64
"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run transfer_public_to_private aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 30u64

echo "
When calling transfer_public_to_private, we see the finalize function with the arguments to modify Alice's public token mapping (address, amount), and a private record created that's owned by Bob and contains 110 tokens.

###############################################################################
########                                                               ########
########     STEP 4: Convert 30 public tokens from Alice into 30       ########
########             private tokens for Bob.                           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PUBLIC BALANCES            |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          60         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          10         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PRIVATE BALANCES           |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          20         |           ########
########           -----------------------------------------           ########
########           |        Bob      |         110         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Let's convert 40 of Bob's private tokens into 40 public tokens for Alice. Switch the private key back to Bob.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run transfer_private_to_public '{
    owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
    amount: 80u64.private,
    _nonce: 1852830456042139988098466781381363679605019151318121788109768539956661608520group.public
}' aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 40u64
"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run transfer_private_to_public "{
    owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
    amount: 80u64.private,
    _nonce: 1852830456042139988098466781381363679605019151318121788109768539956661608520group.public
}" aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 40u64

echo "
When we call transfer_private_to_public, we take Bob's private record that contains 110 tokens, and outputs a record owned by Bob with 70 tokens, and calls the finalize function under transfer_private_to_public with Alice's address and 40 tokens as arguments. This changes the public mapping under Alice's address to contain 100 public tokens. Again, public mappings are queryable on-chain.

###############################################################################
########                                                               ########
########     STEP 5: Convert 40 private tokens from Bob into 40        ########
########             public tokens for Alice.                          ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PUBLIC BALANCES            |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |         100         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          10         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |            PRIVATE BALANCES           |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Alice    |          20         |           ########
########           -----------------------------------------           ########
########           |        Bob      |          70         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

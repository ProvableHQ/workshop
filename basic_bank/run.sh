#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We will be playing the role of two parties.

The private key and address of the bank.
private_key: APrivateKey1zkpHtqVWT6fSHgUMNxsuVf7eaR6id2cj7TieKY1Z8CP5rCD
address: aleo1t0uer3jgtsgmx5tq6x6f9ecu8tr57rzzfnc2dgmcqldceal0ls9qf6st7a

The private key and address of the user.
private_key: APrivateKey1zkp75cpr5NNQpVWc5mfsD9Uf2wg6XvHknf82iwB636q3rtc
address: aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg
"

echo "
Let's make some bank transactions. We'll take the role of the bank and issue 100 tokens to the user. We swap the private key into .env and run the issue transition function. The inputs are simply the recipient of the issuance and the amount.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpHtqVWT6fSHgUMNxsuVf7eaR6id2cj7TieKY1Z8CP5rCD
' > .env

leo run issue aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg 100u64
"

# Swap in the private key of the bank to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpHtqVWT6fSHgUMNxsuVf7eaR6id2cj7TieKY1Z8CP5rCD
" > .env

# Have the bank issue 100 tokens to the user.
leo run issue aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg 100u64

echo "
###############################################################################
########                                                               ########
########   Step 0: Initialize 100 tokens for aleo1zeklp...v46ngg       ########
########                                                               ########
########           -----------------------------------------           ########
########           |      ACTION     |        AMOUNT       |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Issuing  |         100         |           ########
########           -----------------------------------------           ########
########           |     Depositing  |          0          |           ########
########           -----------------------------------------           ########
########           |    Withdrawing  |          0          |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      WALLET     | aleo1zeklp...v46ngg |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |         100         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      BANK       | aleo1t0uer...f6st7a |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |          0          |           ########
########           -----------------------------------------           ########
########           |        Periods  |          0          |           ########
########           -----------------------------------------           ########
########           |  Interest Rate  |        12.34%       |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |  TOTAL BALANCE  |         100         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Now, let's have the user deposit 50 of their tokens with the bank. We'll take the role of the user and call the deposit function, having the user use the output record that was issued to them by the bank. The inputs are the output record from the issue transition and the amount the user wishes to deposit.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp75cpr5NNQpVWc5mfsD9Uf2wg6XvHknf82iwB636q3rtc
' > .env

leo run deposit '{
    owner: aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg.private,
    amount: 100u64.private,
    _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
}'  50u64
"

# Swap in the private key of the user to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp75cpr5NNQpVWc5mfsD9Uf2wg6XvHknf82iwB636q3rtc
" > .env

# Have the user deposit 50 tokens into the bank.
leo run deposit "{
    owner: aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg.private,
    amount: 100u64.private,
    _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
}"  50u64

echo "
You'll see that the output contains a new private record belonging to the user with 50 credits, and a finalize deposit function taking the arguments (bank address, amount) that will update a public mapping with 50 credits. This information is queryable on-chain.
"

echo "
###############################################################################
########                                                               ########
########        Step 1: aleo1zeklp...v46ngg deposits 50 tokens         ########
########                                                               ########
########           -----------------------------------------           ########
########           |      ACTION     |        AMOUNT       |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Issuing  |          0          |           ########
########           -----------------------------------------           ########
########           |     Depositing  |          50         |           ########
########           -----------------------------------------           ########
########           |    Withdrawing  |          0          |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      WALLET     | aleo1zeklp...v46ngg |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |          50         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      BANK       | aleo1t0uer...f6st7a |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |          50         |           ########
########           -----------------------------------------           ########
########           |        Periods  |          0          |           ########
########           -----------------------------------------           ########
########           |  Interest Rate  |        12.34%       |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |  TOTAL BALANCE  |         100         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
With the 50 token deposit, let's say 15 periods of time pass with compounding interest at a rate of 12.34% on the principal amount.

###############################################################################
########                                                               ########
########                   Step 2: Wait 15 periods                     ########
########                                                               ########
########           -----------------------------------------           ########
########           |      ACTION     |        AMOUNT       |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Issuing  |          0          |           ########
########           -----------------------------------------           ########
########           |     Depositing  |          0          |           ########
########           -----------------------------------------           ########
########           |    Withdrawing  |          0          |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      WALLET     | aleo1zeklp...v46ngg |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |          50         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      BANK       | aleo1t0uer...f6st7a |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |         266         |           ########
########           -----------------------------------------           ########
########           |        Periods  |          15         |           ########
########           -----------------------------------------           ########
########           |  Interest Rate  |        12.34%       |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |  TOTAL BALANCE  |         316         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

echo "
Now, let's have the bank withdraw all tokens after 15 periods. Let's switch to the bank role, and call the withdraw transition function. The inputs are the recipient's address, amount, rate, and periods.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpHtqVWT6fSHgUMNxsuVf7eaR6id2cj7TieKY1Z8CP5rCD
' > .env

leo run withdraw aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg 50u64 1234u64 15u64

"
# Swap in the private key of the bank to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpHtqVWT6fSHgUMNxsuVf7eaR6id2cj7TieKY1Z8CP5rCD
" > .env

# Have the bank withdraw all of the user's tokens with compound interest over 15 periods at 12.34%.
leo run withdraw aleo1zeklp6dd8e764spe74xez6f8w27dlua3w7hl4z2uln03re52egpsv46ngg 50u64 1234u64 15u64

echo "
You'll see here the withdrawal function creates a new private record for the user containing all 266 withdrawn tokens, and then calls the finalize withdraw function with arguments (address, amount), which will update the public balance of the bank back to 0. The public mapping will be queryable on-chain.
"

echo "
###############################################################################
########                                                               ########
########  Step 3: Withdraw tokens of aleo1zeklp...v46ngg w/ interest   ########
########                                                               ########
########           -----------------------------------------           ########
########           |      ACTION     |        AMOUNT       |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Issuing  |          0          |           ########
########           -----------------------------------------           ########
########           |     Depositing  |          0          |           ########
########           -----------------------------------------           ########
########           |    Withdrawing  |         266         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      WALLET     | aleo1zeklp...v46ngg |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |         316         |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |      BANK       | aleo1t0uer...f6st7a |           ########
########           -----------------------------------------           ########
########           -----------------------------------------           ########
########           |        Balance  |          0          |           ########
########           -----------------------------------------           ########
########           |        Periods  |          15         |           ########
########           -----------------------------------------           ########
########           |  Interest Rate  |        12.34%       |           ########
########           -----------------------------------------           ########
########                                                               ########
########           -----------------------------------------           ########
########           |  TOTAL BALANCE  |         316         |           ########
########           -----------------------------------------           ########
########                                                               ########
###############################################################################
"

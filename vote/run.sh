#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We will be playing the role of three parties.

The private key and address of the proposer.
private_key: APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
address: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px

The private key and address of voter 1.
private_key: APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
address: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t

The private key and address of voter 2.
private_key: APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
address: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg
"

echo "
Let's propose a new ballot. Take on the role of the proposer and run the propose transition function. We've provided the necessary information as inputs to the propose function.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run propose '{ 
  title: 2077160157502449938194577302446444field, 
  content: 1452374294790018907888397545906607852827800436field, 
  proposer: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px
}'
"

# swaps in the private key of the proposer to .env
echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

# runs the propose transition function with proposal info as the input
leo run propose "{ 
  title: 2077160157502449938194577302446444field, 
  content: 1452374294790018907888397545906607852827800436field, 
  proposer: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px
}"

echo "
You'll see that the output generates a new record with the proposal information and sets a public mapping with the proposal id as an argument input. The public mapping will be queryable on-chain.
"

echo "
###############################################################################
########                                                               ########
########                  Step 0: Propose a new ballot                 ########
########                                                               ########
########                  ---------------------------                  ########
########                  |         |  Yes  |   No  |                  ########
########                  ---------------------------                  ########
########                  |  Votes  |       |       |                  ########
########                  ---------------------------                  ########
########                                                               ########
###############################################################################
"

echo "
Let's create a new private ticket to make a vote. Take on the role of voter 1 and run the new_ticket transition. The inputs take a unique ticket ID and the voter's public address.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run new_ticket 2264670486490520844857553240576860973319410481267184439818180411609250173817field aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t
"

# Swap in the private key of voter 1 to .env.
echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

# Runs the new_ticket transition function with unique id and voter address as inputs.
leo run new_ticket 2264670486490520844857553240576860973319410481267184439818180411609250173817field aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t

echo "
You'll see a new private ticket created belonging to the owner, and a public mapping in the vote program to track the ID of that ticket.
"

echo "
###############################################################################
########                                                               ########
########           Step 1: Voter 1 issues a new ballot ticket          ########
########                                                               ########
########                  ---------------------------                  ########
########                  |         |  Yes  |   No  |                  ########
########                  ---------------------------                  ########
########                  |  Votes  |   0   |   0   |                  ########
########                  ---------------------------                  ########
########                                                               ########
###############################################################################
"

echo "
Voter 1 can now vote privately on their ticket. Call the agree or disagree transition function, which takes the voter's ticket output as the input.

leo run agree '{
  owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
  pid: 2264670486490520844857553240576860973319410481267184439818180411609250173817field.private,
  _nonce: 1738483341280375163846743812193292672860569105378494043894154684192972730518group.public
}'
"

leo run agree "{
  owner: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
  pid: 2264670486490520844857553240576860973319410481267184439818180411609250173817field.private,
  _nonce: 1738483341280375163846743812193292672860569105378494043894154684192972730518group.public
}"

echo "
###############################################################################
########                                                               ########
########           Voter 1 votes 'yes' on their ballot ticket          ########
########                                                               ########
########                  ---------------------------                  ########
########                  |         |  Yes  |   No  |                  ########
########                  ---------------------------                  ########
########                  |  Votes  |   1   |   0   |                  ########
########                  ---------------------------                  ########
########                                                               ########
###############################################################################
"

echo "
Let's create a new private ticket for voter 2. Take on the role of voter 1 and run the new_ticket transition. The inputs take a unique ticket ID and the voter's public address.

echo '
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
ENDPOINT=https://api.explorer.aleo.org/v1
' > .env

leo run new_ticket 2158670485494560943857353240576760973319410481267184429818180411607250143681field aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg
"

# Swap in the private key of voter 2 to .env.
echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

# Run the new_ticket transition function with unique id and voter address as inputs.
leo run new_ticket 2158670485494560943857353240576760973319410481267184429818180411607250143681field aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg

echo "
###############################################################################
########                                                               ########
########           Step 2: Voter 2 issues a new ballot ticket          ########
########                                                               ########
########                  ---------------------------                  ########
########                  |         |  Yes  |   No  |                  ########
########                  ---------------------------                  ########
########                  |  Votes  |   0   |   0   |                  ########
########                  ---------------------------                  ########
########                                                               ########
###############################################################################
"

echo "
Voter 2 can now vote privately on their ticket. Call the agree or disagree transition function, which takes the voter's ticket output as the input.

leo run disagree '{
  owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
  pid: 2158670485494560943857353240576760973319410481267184429818180411607250143681field.private,
  _nonce: 6511154004161574129036815174288926693337549214513234790975047364416273541105group.public
}'
"

leo run disagree "{
  owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
  pid: 2158670485494560943857353240576760973319410481267184429818180411607250143681field.private,
  _nonce: 6511154004161574129036815174288926693337549214513234790975047364416273541105group.public
}"

echo "
###############################################################################
########                                                               ########
########            Voter 2 votes 'no' on their ballot ticket          ########
########                                                               ########
########                  ---------------------------                  ########
########                  |         |  Yes  |   No  |                  ########
########                  ---------------------------                  ########
########                  |  Votes  |   0   |   1   |                  ########
########                  ---------------------------                  ########
########                                                               ########
###############################################################################
"

echo "
Votes on the ticket are private. But the sum total of the agreements and disagreements are shown on-chain in the public mapping. You can query this data on-chain.

###############################################################################
########                                                               ########
########                   Step 3: Tallying the Votes                  ########
########                                                               ########
########                  ---------------------------                  ########
########                  |         |  Yes  |   No  |                  ########
########                  ---------------------------                  ########
########                  |  Votes  |   1   |   1   |                  ########
########                  ---------------------------                  ########
########                                                               ########
###############################################################################
"

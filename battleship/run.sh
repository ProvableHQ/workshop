#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We will be playing the role of these two parties:

# The private key and address of player 1.
# "private_key": "APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm",
# "address": "aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy"

# The private key and address of player 2.
# "private_key": "APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH"
# "address": "aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry"
"

echo "
###############################################################################
########                                                               ########
########                 STEP 1: Initializing Player 1                 ########
########                                                               ########
###############################################################################

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
' > .env
"

echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
" > .env

echo "
###############################################################################
########                                                               ########
########           STEP 2: Player 1 Places Ships On The Board          ########
########                                                               ########
###############################################################################

With player 1's private key, they initialize the board with the placement of 4 ships and the opponent's public address.

leo run initialize_board 34084860461056u64 551911718912u64 7u64 1157425104234217472u64 aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry
"

leo run initialize_board 34084860461056u64 551911718912u64 7u64 1157425104234217472u64 aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry

echo "
###############################################################################
########                                                               ########
########         STEP 3: Player 1 Passes The Board To Player 2         ########
########                                                               ########
###############################################################################

Player 1 "passes the board" as an offer to play battleship with player 2.

leo run offer_battleship '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 1157459741006397447u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: false.private,
  _nonce: 3887646704618532506963887075433683846689834495661101507703164090915348189037group.public
}'
"
leo run offer_battleship "{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 1157459741006397447u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: false.private,
  _nonce: 3887646704618532506963887075433683846689834495661101507703164090915348189037group.public
}"

echo "
###############################################################################
########                                                               ########
########           STEP 4: Player 2 Places Ships On The Board          ########
########                                                               ########
###############################################################################

We switch our .env to player 2's private key and similarly run initialize_board to create a new and different board for player two. 

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
' > .env

leo run initialize_board 31u64 2207646875648u64 224u64 9042383626829824u64 aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy
"

echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
" > .env

leo run initialize_board 31u64 2207646875648u64 224u64 9042383626829824u64 aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy

echo "
###############################################################################
########                                                               ########
########          STEP 5: Passing The Board Back To Player 1           ########
########                                                               ########
###############################################################################

Player 2 accepts player 1's offer to play and starts a game of battleship.

leo run start_battleship '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 9044591273705727u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: false.private,
  _nonce: 1549419609469324182591325047490602235361156298832591378925133482196483208807group.public
}' '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  incoming_fire_coordinate: 0u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 4374626042494973146987320062571809401151262172766172816829659487584978644457group.public
}'
"

leo run start_battleship "{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 9044591273705727u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: false.private,
  _nonce: 1549419609469324182591325047490602235361156298832591378925133482196483208807group.public
}" "{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  incoming_fire_coordinate: 0u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 4374626042494973146987320062571809401151262172766172816829659487584978644457group.public
}"

echo "
###############################################################################
########                                                               ########
########               STEP 6: Player 1 Takes The 1st Turn             ########
########                                                               ########
###############################################################################

We switch the .env back to player 1, and we run the transition function play.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
' > .env

leo run play '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 1157459741006397447u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: true.private,
  _nonce: 6563064852163330630334088854834332804417910882908622526775624018226782316843group.public
}' '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  incoming_fire_coordinate: 0u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 3742551407126138397717446975757978589064777004441277005584760115236217735495group.public
}' 1u64 
"

echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
" > .env

leo run play "{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 1157459741006397447u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: true.private,
  _nonce: 6563064852163330630334088854834332804417910882908622526775624018226782316843group.public
}" "{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  incoming_fire_coordinate: 0u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 3742551407126138397717446975757978589064777004441277005584760115236217735495group.public
}" 1u64

echo "
###############################################################################
########                                                               ########
########               STEP 7: Player 2 Takes The 2nd Turn             ########
########                                                               ########
###############################################################################

We switch the .env back to player 2, and we run the transition function play.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
' > .env

leo run play '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 9044591273705727u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: true.private,
  _nonce: 6222383571142756260765569201308836492199048237638652378826141459336360362251group.public
}' '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  incoming_fire_coordinate: 1u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 5481529266389297320813092061136936339861329677911328036818179854958874588416group.public
}' 2048u64 || exit
"

echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
" > .env

leo run play "{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  hits_and_misses: 0u64.private,
  played_tiles: 0u64.private,
  ships: 9044591273705727u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: true.private,
  _nonce: 6222383571142756260765569201308836492199048237638652378826141459336360362251group.public
}" "{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  incoming_fire_coordinate: 1u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 5481529266389297320813092061136936339861329677911328036818179854958874588416group.public
}" 2048u64

echo "
###############################################################################
########                                                               ########
########              STEP 8: Player 1 Takes The 3rd Turn              ########
########                                                               ########
###############################################################################

We switch the .env back to player 1, and we run the transition function play.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
' > .env

leo run play '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  hits_and_misses: 0u64.private,
  played_tiles: 1u64.private,
  ships: 1157459741006397447u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: true.private,
  _nonce: 1474170213684980843727833284550698461565286563122422722760769547002894080093group.public
}' '{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  incoming_fire_coordinate: 2048u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  prev_hit_or_miss: 1u64.private,
  _nonce: 5851606198769770675504009323414373017067582072428989801313256693053765675198group.public
}' 2u64 || exit
"

echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpGKaJY47BXb6knSqmT3JZnBUEGBDFAWz2nMVSsjwYpJmm
" > .env

leo run play "{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  hits_and_misses: 0u64.private,
  played_tiles: 1u64.private,
  ships: 1157459741006397447u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  game_started: true.private,
  _nonce: 1474170213684980843727833284550698461565286563122422722760769547002894080093group.public
}" "{
  owner: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  incoming_fire_coordinate: 2048u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  prev_hit_or_miss: 1u64.private,
  _nonce: 5851606198769770675504009323414373017067582072428989801313256693053765675198group.public
}" 2u64

echo "
###############################################################################
########                                                               ########
########               STEP 9: Player 2 Takes The 4th Turn             ########
########                                                               ########
###############################################################################

We switch the .env back to player 2, and we run the transition function play.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
' > .env

leo run play '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  hits_and_misses: 0u64.private,
  played_tiles: 2048u64.private,
  ships: 9044591273705727u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: true.private,
  _nonce: 5254963165391133332409074172682159033621708071536429341861038147524454777097group.public
}' '{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  incoming_fire_coordinate: 2u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 710336412388939616658264778971886770861024495941253598683184288448156545822group.public
}' 4u64 || exit
"

echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp86FNGdKxjgAdgQZ967bqBanjuHkAaoRe19RK24ZCGsHH
" > .env

leo run play "{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  hits_and_misses: 0u64.private,
  played_tiles: 2048u64.private,
  ships: 9044591273705727u64.private,
  player_1: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  player_2: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  game_started: true.private,
  _nonce: 5254963165391133332409074172682159033621708071536429341861038147524454777097group.public
}" "{
  owner: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  incoming_fire_coordinate: 2u64.private,
  player_1: aleo15g9c69urtdhvfml0vjl8px07txmxsy454urhgzk57szmcuttpqgq5cvcdy.private,
  player_2: aleo1wyvu96dvv0auq9e4qme54kjuhzglyfcf576h0g3nrrmrmr0505pqd6wnry.private,
  prev_hit_or_miss: 0u64.private,
  _nonce: 710336412388939616658264778971886770861024495941253598683184288448156545822group.public
}" 4u64 || exit

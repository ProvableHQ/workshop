<!-- # 🪙 Token -->
<img alt="workshop/token" width="1412" src="../.resources/token.png">

## Summary

A transparent & shielded custom token in Leo.

## How to Run

Follow the [Leo Installation Instructions](https://developer.aleo.org/leo/installation).

This token program can be run using the following bash script. Locally, it will execute Leo program functions to mint and transfer tokens publicly and privately.


```bash
cd token
./run.sh
```

The `.env` file contains a private key and address. This is the account that will be used to sign transactions and is checked for record ownership. When executing programs as different parties, be sure to set the `private_key` field in `.env` to the appropriate value. You can check out how we've set things up in `./run.sh` for a full example of how to run the program as different parties.

## Walkthrough

* [Step 0: Public Mint](#step0)
* [Step 1: Private Mint](#step1)
* [Step 2: Public Transfer](#step2)
* [Step 3: Private Transfer](#step3)
* [Step 4: Public to Private Transfer](#step4)
* [Step 5: Private to Public Transfer](#step5)

We'll be conducting a transfer between two parties.

```bash
The private key and address of Alice.
private_key: APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR
address: aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q

The private key and address of Bob.
private_key: APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF
address: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z
```

## <a id="step0"></a> Public Mint

Let's play Alice. Swap in her private key and publicly mint 100 tokens.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR
" > .env

leo run mint_public aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q 100u64
```

You can see the output of the finalize function of `mint_public`, which takes the arguments Alice's address and the amount of tokens to mint publicly. This information is shown on-chain and can be queried on a network.

## <a id="step1"></a> Private Mint

Now let's privately mint 100 tokens for Bob. Switch to Bob's private key and privately mint 100 tokens for Bob.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF
" > .env

leo run mint_private aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z 100u64
```

The output is a private record.

## <a id="step2"></a> Public Transfer

Let's publicly transfer 10 tokens from Alice to Bob. Swap the private key back to Alice and call the public transfer transition.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR
" > .env

leo run transfer_public aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z 10u64
```

Again, we see the arguments used for the finzalize function of `transfer_public` - Alice's address, Bob's address, and the amount to transfer. The public mapping will be queryable on-chain.

## <a id="step3"></a> Private Transfer

Let's privately transfer 20 tokens from Bob to Alice. Switch to Bob's private key and call the private transfer transition.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF
" > .env

leo run transfer_private "{
    owner: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z.private,
    amount: 100u64.private,
    _nonce: 6586771265379155927089644749305420610382723873232320906747954786091923851913group.public
}" aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q 20u64
```

The output of `transfer_private` is a record owned by Bob less the 20 tokens he privately transferred to Alice, and a record owned by Alice with the 20 tokens Bob transferred to Alice.

## <a id="step4"></a> Public to Private Transfer

Let's convert 30 of Alice's public tokens into 30 private tokens for Bob. Switch the private key back to Alice.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR
" > .env

leo run transfer_public_to_private aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z 30u64
```

When calling `transfer_public_to_private`, we see the finalize function with the arguments to modify Alice's public token mapping (address, amount), and a private record created that's owned by Bob and contains 110 tokens.

## <a id="step5"></a> Private to Public Transfer

Let's convert 40 of Bob's private tokens into 40 public tokens for Alice. Switch the private key back to Bob.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF
" > .env

leo run transfer_private_to_public "{
    owner: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z.private,
    amount: 80u64.private,
    _nonce: 1852830456042139988098466781381363679605019151318121788109768539956661608520group.public
}" aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q 40u64
```

When we call `transfer_private_to_public`, we take Bob's private record that contains 110 tokens, and outputs a record owned by Bob with 70 tokens, and calls the finalize function under `transfer_private_to_public` with Alice's address and 40 tokens as arguments. This changes the public mapping under Alice's address to contain 100 public tokens. Again, public mappings are queryable on-chain.

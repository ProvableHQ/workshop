<!-- # 🗳️ Vote -->
<img alt="workshop/vote" width="1412" src="../.resources/vote.png">

## Summary

`vote.leo` is a general vote program.

Anyone can issue new proposals, proposers can issue tickets to the voters, and voters can vote without exposing their identity.

This example is inspired by the [aleo-vote](https://github.com/zkprivacy/aleo-vote) example written by the Aleo community.

## Noteworthy Features

Voter identity is concealed by privately passing a voter's ballot into a function.
Proposal information and voting results are revealed using the public `mapping` datatype in Leo.

## How to Run

The example should work out of the box. We recommend running the entire script, and then creating your own accounts to replicate the functionality. Run the entire script:

```bash
cd vote
./run.sh
```

The `.env` file contains a private key and address. This is the account that will be used to sign transactions and is checked for record ownership. When executing programs as different parties, be sure to set the `private_key` field in `.env` to the appropriate value. You can check out how we've set things up in `./run.sh` for a full example of how to run the program as different parties.


## Walkthrough

* [Create a Proposal](#step0)
* [Voter 1 makes a vote](#step1)
* [Voter 2 makes a vote](#step2)
* [How votes are tallied](#step3)






## <a id="functions"></a> Functions

### Propose

Anyone can issue a new proposal publicly by calling `propose` function.

Run `propose`:

```
leo run propose
```

Output sample:

```
 {
  owner: aleo1kkk52quhnxgn2nfrcd9jqk7c9x27c23f2wvw7fyzcze56yahvcgszgttu2.private,
  id: 2805252584833208809872967597325381727971256629741137995614832105537063464740field.private,
  info: {
    title: 2077160157502449938194577302446444field.private,
    content: 1452374294790018907888397545906607852827800436field.private,
    proposer: aleo1kkk52quhnxgn2nfrcd9jqk7c9x27c23f2wvw7fyzcze56yahvcgszgttu2.private
  },
  _nonce: 1639660347839832220966145410710039205878572956621820215177036061076060242021group.public
}
```

### Create Ticket

Proposers can create new tickets for proposed proposals.

Ticket is a record with `owner` and `pid`, 
it can be used to vote for the specific proposal - `pid`, 
and can only be used(voted) by the ticket `owner`.

Run `new_ticket`:

```
leo run new_ticket
```

Output sample:

```
{
  owner: aleo1kkk52quhnxgn2nfrcd9jqk7c9x27c23f2wvw7fyzcze56yahvcgszgttu2.private,
  pid: 2264670486490520844857553240576860973319410481267184439818180411609250173817field.private,
  _nonce: 1637267040221574073903539416642641433705357302885235345311606754421919550724group.public
}
```

### Vote

A ticket owner can use their ticket record to vote `agree` / `disagree` with the specific proposal - `pid`.

Since the ticket record can be used as an input privately, the voter's privacy is protected.

Run `agree`:

```
leo run agree
```

Run `disagree`:

```
leo run disagree
```


## <a id="step0"></a> Create a Proposal

We will be playing the role of three parties.

```bash
The private key and address of the proposer.
private_key: APrivateKey1zkp8wKHF9zFX1j4YJrK3JhxtyKDmPbRu9LrnEW8Ki56UQ3G
address: aleo1rfez44epy0m7nv4pskvjy6vex64tnt0xy90fyhrg49cwe0t9ws8sh6nhhr

The private key and address of voter 1.
private_key: APrivateKey1zkpHmSu9zuhyuCJqVfQE8p82HXpCTLVa8Z2HUNaiy9mrug2
address: aleo1c45etea8czkyscyqawxs7auqjz08daaagp2zq4qjydkhxt997q9s77rsp2

The private key and address of voter 2.
private_key: APrivateKey1zkp6NHwbT7PkpnEFeBidz5ZkZ14W8WXZmJ6kjKbEHYdMmf2
address: aleo1uc6jphye8y9gfqtezrz240ak963sdgugd7s96qpuw6k7jz9axs8q2qnhxc
```
Let's propose a new ballot. Take on the role of the proposer and run the propose transition function. We've provided the necessary information as inputs to the `propose` function.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp8wKHF9zFX1j4YJrK3JhxtyKDmPbRu9LrnEW8Ki56UQ3G
" > .env

leo run propose "{ 
  title: 2077160157502449938194577302446444field, 
  content: 1452374294790018907888397545906607852827800436field, 
  proposer: aleo1rfez44epy0m7nv4pskvjy6vex64tnt0xy90fyhrg49cwe0t9ws8sh6nhhr
}"
```

You'll see that the output generates a new record with the proposal information and sets a public mapping with the proposal id as an argument input. The public mapping will be queryable on-chain.

## <a id="step1"></a> Voter 1 makes a vote

Let's create a new private ticket to make a vote. Take on the role of voter 1 and run the `new_ticket` transition. The inputs take a unique ticket ID and the voter's public address.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpHmSu9zuhyuCJqVfQE8p82HXpCTLVa8Z2HUNaiy9mrug2
" > .env

leo run new_ticket 2264670486490520844857553240576860973319410481267184439818180411609250173817field aleo1c45etea8czkyscyqawxs7auqjz08daaagp2zq4qjydkhxt997q9s77rsp2
```

You'll see a new private ticket created belonging to the owner, and a public mapping in the vote program to track the ID of that ticket.

Voter 1 can now vote privately on their ticket. Call the agree or disagree transition function, which takes the voter's ticket output as the input.

```bash
leo run agree "{
  owner: aleo1c45etea8czkyscyqawxs7auqjz08daaagp2zq4qjydkhxt997q9s77rsp2.private,
  pid: 2264670486490520844857553240576860973319410481267184439818180411609250173817field.private,
  _nonce: 1738483341280375163846743812193292672860569105378494043894154684192972730518group.public
}"
```

## <a id="step2"></a> Voter 2 makes a vote

Let's create a new private ticket for voter 2. Take on the role of voter 1 and run the new_ticket transition. The inputs take a unique ticket ID and the voter's public address.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp6NHwbT7PkpnEFeBidz5ZkZ14W8WXZmJ6kjKbEHYdMmf2
" > .env

leo run new_ticket 2158670485494560943857353240576760973319410481267184429818180411607250143681field aleo1uc6jphye8y9gfqtezrz240ak963sdgugd7s96qpuw6k7jz9axs8q2qnhxc
```

Voter 2 can now vote privately on their ticket. Call the agree or disagree transition function, which takes the voter's ticket output as the input.

```bash
leo run disagree "{
  owner: aleo1uc6jphye8y9gfqtezrz240ak963sdgugd7s96qpuw6k7jz9axs8q2qnhxc.private,
  pid: 2158670485494560943857353240576760973319410481267184429818180411607250143681field.private,
  _nonce: 6511154004161574129036815174288926693337549214513234790975047364416273541105group.public
}"
```

## <a id="step3"></a> How votes are tallied

Votes on the ticket are private. But the sum total of the agreements and disagreements are shown on-chain in the public mapping. You can query this data on-chain.
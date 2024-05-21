<!-- # 🏛️ Blind Auction -->
<img alt="workshop/auction" width="1412" src="../.resources/auction.png">

A first-price sealed-bid auction in Leo.

## Summary

A first-price sealed-bid auction (or blind auction) is a type of auction in which each participant submits a bid without knowing the bids of the other participants.
The bidder with the highest bid wins the auction.

In this model, there are two parties: the auctioneer and the bidders.
- **Bidder**: A participant in the auction.
- **Auctioneer**: The party responsible for conducting the auction.

We make following assumptions about the auction:
- The auctioneer is honest. That is, the auctioneer will resolve **all** bids in the order they are received. The auctioneer will not tamper with the bids.
- There is no limit to the number of bids.
- The auctioneer knows the identity of all bidders, but bidders do not necessarily know the identity of other bidders.

Under this model, we require that:
- Bidders do not learn any information about the value of other bids.

## Auction Flow

The auction is conducted in a series of stages.
- **Bidding**: In the bidding stage, bidders submit bids to the auctioneer. They do so by invoking the `place_bid` function.
- **Resolution**:  In the resolution stage, the auctioneer resolves the bids in the order they were received. The auctioneer does so by invoking the `resolve` function. The resolution process produces a single winning bid.
- **Finishing**: In this stage, the auctioneer finishes the auction by invoking the `finish` function. This function returns the winning bid to the bidder, which the bidder can then use to claim the item.

## Language Features and Concepts
- `record` declarations
- `assert_eq`
- record ownership

## How to Run

Follow the [Leo Installation Instructions](https://developer.aleo.org/leo/installation).

This auction program can be run using the following bash script. Locally, it will execute Leo program functions to conduct, bid, and close a three party auction.

```bash
cd auction
./run.sh
```

The `.env` file contains a private key and address. This is the account that will be used to sign transactions and is checked for record ownership. When executing programs as different parties, be sure to set the `private_key` field in `.env` to the appropriate value. You can check out how we've set things up in `./run.sh` for a full example of how to run the program as different parties.

## Walkthrough

* [Step 0: Initializing the Auction](#step0)
* [Step 1: The First Bid](#step1)
* [Step 2: The Second Bid](#step2)
* [Step 3: Select the Winner](#step3)

## <a id="step0"></a> Step 0: Initializing the Auction

The three parties we'll be emulating are as follows:

```markdown
First Bidder Private Key:  
APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
First Bidder Address: 
aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px

Second Bidder Private Key:
APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
Second Bidder Address:
aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t

Auctioneer Private Key:
APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
Auctioneer Address:
aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg
```

## <a id="step1"></a> Step 1: The First Bid

Have the first bidder place a bid of 10. 

Swap in the private key and address of the first bidder to `.env`.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
" > .env
```

Call the `place_bid` program function with the first bidder and `10u64` arguments.

```bash
leo run place_bid aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 10u64
```

## <a id="step2"></a> Step 2: The Second Bid

Have the second bidder place a bid of 90.

Swap in the private key of the second bidder to `.env`.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh
" > .env
```

Call the `place_bid` program function with the second bidder and `90u64` arguments.

```bash
leo run place_bid aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 90u64
```

## <a id="step3"></a> Step 3: Select the Winner

Have the auctioneer select the winning bid.

Swap in the private key of the auctioneer to `.env`.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG
" > .env
```

Provide the two `Bid` records as input to the `resolve` transition function.

```bash 
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
```

## <a id="step4"></a> Step 4: Finish the Auction

Call the `finish` transition function with the winning `Bid` record.

```bash 
leo run finish "{
    owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
    bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
    amount: 90u64.private,
    is_winner: false.private,
    _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
}"
```

Congratulations! You've run a private auction. We recommend going to [provable.tools](https://provable.tools) to generate new accounts and trying the same commands with those addresses.

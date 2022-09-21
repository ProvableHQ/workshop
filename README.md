<h1 align="center">Aleo Workshop</h1>
<h3 align="center">📜 A starter guide to build applications on Aleo 📜</h3>

<p align="center">
    <a href="https://twitter.com/AleoHQ"><img src="https://img.shields.io/twitter/url/https/twitter.com/AleoHQ.svg?style=social&label=Follow%20%40AleoHQ"></a>
    <a href="https://aleo.org/discord"><img src="https://img.shields.io/discord/700454073459015690?logo=discord"/></a>
</p>

## Table of Contents
- [Build Guide](#build-guide)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
- [IDE Support](#ide-support)
- [Application Walkthroughs](#application-walkthroughs)
    - [🏛️ Auction](#🏛️-auction) ([Source Code](./auction/))
    - [🏦 Basic Bank](#🏦-basic-bank) ([Source Code](./basic_bank/))
    - [🛳️ Battleship](#🛳️-battleship) ([Source Code](./battleship/))
    - [⭕ Tic-Tic-Toe](#⭕-tic-tac-toe) ([Source Code](./tictactoe/))
    - [🪙 Token](#🪙-token) ([Source Code](./token))
    - [🗳️ Vote](#🗳️-vote) ([Source Code](./vote/))

## Build Guide

The following steps will install Aleo and Leo on your machine. This workshop is compatible on macOS, Linux, and Windows machines.

### Prerequisites

This workshop requires the following prerequisites.

- Install `git` with [bit.ly/start-git](https://bit.ly/start-git)
- Install `Rust`with [bit.ly/start-rust](https://bit.ly/start-rust)

### Installation

To install Aleo and Leo, run:
```
./install.sh
```

## IDE Support

This workshop requires one of the following IDEs.
- [VSCode](https://bit.ly/start-vscode)
- [Sublime Text](https://bit.ly/start-sublime)
- [IntelliJ IDEA](https://bit.ly/start-intellij)

### VSCode

Start by installing `VSCode` with [bit.ly/start-vscode](https://bit.ly/start-vscode).

<details><summary>Installation Steps</summary>

#### Next, in VSCode, open the **VSCode Marketplace**, type **Leo** into the search bar, and proceed to install the Leo plugin.
![Leo VSCode](./.resources/leo-vscode.png)

</details>

### Sublime Text

Start by installing `Sublime Text` with [bit.ly/start-sublime](https://bit.ly/start-sublime).

<details><summary>Installation Steps</summary>

#### Next, in Sublime Text, install [Package Control](https://packagecontrol.io):
- On Windows/Linux: `ctrl + shift + p`, type **Install Package Control**, and press **Enter**.
- On macOS: `cmd + shift + p`, type **Install Package Control**, and press **Enter**.

#### Next, in Sublime Text, install [LSP](https://packagecontrol.io/packages/LSP):
- On Windows/Linux: `ctrl + shift + p`, select **Package Control: Install Package**, type **LSP**, and press **Enter**.
- On macOS: `cmd + shift + p`, select **Package Control: Install Package**, type **LSP**, and press **Enter**.

#### Lastly, in Sublime Text, install [LSP-leo](https://packagecontrol.io/packages/LSP-leo):
- On Windows/Linux: `ctrl + shift + p`, select **Package Control: Install Package**, type **LSP-leo**, and press **Enter**.
- On macOS: `cmd + shift + p`, select **Package Control: Install Package**, type **LSP-leo**, and press **Enter**.

</details>

### IntelliJ IDEA

Start by installing `IntelliJ IDEA` with [bit.ly/start-intellij](https://bit.ly/start-intellij).

<details><summary>Installation Steps</summary>

#### Next, in IntelliJ IDEA, open the **IntelliJ Marketplace** and select `Plugins`:
- On Windows/Linux: `ctrl + ,` and select `Plugins` on the left hand bar
- On macOS: `cmd + ,` and select `Plugins` on the left hand bar

Lastly, type **Leo** into the search bar, and install the official Leo plugin.

</details>

## Application Walkthroughs

This workshop walks through the following applications:
- [auction](./auction/) - A first-price sealed-bid auction in Leo
- [basic_bank](./basic_bank/) - A simple-interest yielding bank account in Leo
- [battleship](./battleship/)- A two-player game of Battleship in Leo
- [tictactoe](./tictactoe/) - A standard game of Tic-Tac-Toe in Leo
- [token](./token) - A transparent & shielded custom token in Leo
- [vote](./vote/) - A ballot voting example in Leo

### 🏛️ Auction

A first-price sealed-bid auction in Leo.

To see the auction example, run:
```
cd auction && ./run.sh
```

### 🏦 Basic Bank

A simple-interest yielding bank account in Leo.

To see the basic bank example, run:
```
cd basic_bank && ./run.sh
```

### 🛳️ Battleship

A two-player game of Battleship in Leo.

To see a game of Battleship between two players, run:
```
cd battleship && ./run.sh
```

### ⭕ Tic-Tac-Toe

A standard game of Tic-Tac-Toe in Leo.

To see a game of Tic-Tac-Toe between two players, run:
```
cd tictactoe && ./run.sh
```

### 🪙 Token

A transparent & shielded custom token in Leo.

To see an example of minting and transfering tokens, run:
```
cd token && ./run.sh
```

### 🗳️ Vote

A ballot voting example in Leo.

To see an example of a ballot, run:
```
cd vote && ./run.sh
```

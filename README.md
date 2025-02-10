### ERC-20 Contract for Starknet

---

## Overview

This repository contains an implementation of an ERC-20 contract written for Starknet. The contract follows the ERC-20 token standard and includes basic functionalities such as transferring tokens, querying balances, and fetching the total supply of tokens.

### Features

- **Token Metadata**:
  - Token name
  - Token symbol
  - Decimals for token precision
- **Core ERC-20 Functions**:
  - `balanceOf`: Get the balance of a specific address.
  - `totalSupply`: Get the total supply of tokens.
  - `transfer`: Transfer tokens from the caller to another address.
- **Event Emission**:
  - Emits a `Transfer` event on token transfers.

---

## Prerequisites

To deploy and interact with this contract, you need:

- **Starknet**: Installed locally.
- **Scarb**: Starknet's package manager.
- **Cairo Compiler**: To compile the contract.
- **Starknet CLI**: For deployment and interaction.

---

## Installation

Clone this repository and navigate to the project directory:

```bash
git clone <repository-url>
cd erc-20-starknet
```

Install dependencies via `Scarb`:

```bash
scarb build
```

---

## Contract Structure

### Storage

The contract defines the following storage variables:

- `owner`: Address of the contract owner.
- `name`: Token name.
- `symbol`: Token symbol.
- `decimals`: Number of decimals for the token.
- `supply`: Total token supply.
- `balances`: Mapping from addresses to their token balances.

### Events

#### Transfer Event
This event is emitted whenever tokens are transferred:

- `from`: Address of the sender.
- `to`: Address of the receiver.
- `value`: Amount of tokens transferred.

### Functions

#### Constructor

Initializes the token metadata, owner, and assigns the initial supply to the owner's address.

```rust
#[constructor]
fn constructor(
    ref self: ContractState,
    owner: ContractAddress,
    name: felt252,
    decimals: u8,
    initial_supply: felt252,
    symbol: felt252
)
```

#### balanceOf

Returns the balance of a given address.

```rust
fn balanceOf(self: @ContractState, address: ContractAddress) -> felt252
```

#### totalSupply

Returns the total supply of the token.

```rust
fn totalSupply(self: @ContractState) -> felt252
```

#### transfer

Transfers tokens from the caller's account to another address and emits a `Transfer` event.

```rust
fn transfer(ref self: ContractState, to: ContractAddress, value: felt252)
```

---

## Deployment

To deploy the contract on Starknet, follow these steps:

1. Compile the contract:
   ```bash
   scarb build
   ```

2. Deploy the compiled contract:
   ```bash
   starknet deploy --contract <path-to-compiled-contract> --network <network>
   ```

3. Note the contract address from the deployment output.

---

## Interaction

### Query Balance

Fetch the balance of a specific address:

```bash
starknet call --address <contract-address> --function balanceOf --inputs <address>
```

### Transfer Tokens

Transfer tokens to another address:

```bash
starknet invoke --address <contract-address> --function transfer --inputs <to-address> <value>
```

### Fetch Total Supply

Get the total supply of the token:

```bash
starknet call --address <contract-address> --function totalSupply
```

---

## Testing

You can add tests using the Starknet testing framework to validate the contract's functionality.

Run the tests:

```bash
scarb test
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- **Starknet**: For the Cairo programming language and Starknet ecosystem.
- **OpenZeppelin**: Inspiration for the ERC-20 token standard.

Feel free to contribute to this project and open issues for any bugs or improvements.
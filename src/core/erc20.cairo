#[starknet::contract]
mod erc_20_contract {
    use starknet::storage::{Map};
    use starknet::storage::{StoragePointerWriteAccess, StorageMapWriteAccess};
    use starknet::{ContractAddress,};
    use crate::interfaces::erc20::IERC20;

    #[storage]
    struct Storage {
        pub owner: ContractAddress,
        pub name: felt252,
        pub symbol: felt252,
        pub decimals: u8,
        pub supply: felt252,
        pub balances: Map<ContractAddress, felt252>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: ContractAddress,
        to: ContractAddress,
        value: felt252,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        name: felt252,
        decimals: u8,
        initial_supply: felt252,
        symbol: felt252
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(decimals);
        self.supply.write(initial_supply);
        self.balances.write(owner, initial_supply);
        self.owner.write(owner);

    }
}

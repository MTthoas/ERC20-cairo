#[starknet::contract]
mod erc_20_contract {
    use starknet::storage::StoragePointerReadAccess;
use starknet::storage::{StoragePathEntry, Map};
    use starknet::storage::{StoragePointerWriteAccess, StorageMapReadAccess, StorageMapWriteAccess};
    use starknet::{ContractAddress, get_caller_address};
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

    #[abi(embed_v0)]
    impl ERC20Impl of IERC20<ContractState> {
        fn balanceOf(self: @ContractState, address: ContractAddress) -> felt252 {
            self.balances.read(address)
        }

        fn totalSupply(self: @ContractState) -> felt252 {
            self.supply.read()
        }

        fn transfer(ref self: ContractState, to: ContractAddress, value: felt252){
            let called = get_caller_address();
            self.balances.write(called, self.balances.read(called) - value);
            self.balances.write(to, self.balances.read(to) + value);
            self.emit(Transfer {
                from: called,
                to: to,
                value: value,
            });
        }
        
    }
}

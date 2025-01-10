#[starknet::contract]
mod ERC20{
    use starknet::storage::StoragePointerWriteAccess;
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry};

    #[storage]
    struct Storage{
        owner: ContractAddress,
        pub name:felt252,
        pub symbol:felt252,
        pub decimals:u8,
        pub supply:u256,
        pub balances: Map::<ContractAddress, u256>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer:Transfer
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer{
        #[key]
        from:ContractAddress,
        #[key]
        to:ContractAddress,
        #[key]
        amount:u256
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress, name:felt252, symbol:felt252, decimals:u8, initial_supply:u256) {
        self.owner.write(owner);
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(decimals);
        self.supply.write(initial_supply);
        self.balances.entry(owner).write(initial_supply);
    }
    
}
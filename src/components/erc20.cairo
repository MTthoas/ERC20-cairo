#[starknet::component]
pub mod erc20_component {
    use starknet::storage::StoragePointerReadAccess;
    use starknet::storage::{StoragePathEntry, Map};
    use starknet::storage::{StoragePointerWriteAccess, StorageMapReadAccess, StorageMapWriteAccess};
    use starknet::{ContractAddress, get_caller_address, get_contract_address};

    // The storage for the ERC20 component.
    // It is a good practice to prefix storage variables with the component name.
    #[storage]
    pub struct Storage {
        owner: ContractAddress,
        name: felt252,
        symbol: felt252,
        decimals: u8,
        supply: u256,
        balances: Map::<ContractAddress, u256>,
    }

    // Declare the Transfer event.
    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        Transfer: Transfer,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        #[key]
        value: u256,
    }

    // Implement the ERC20 functionality as defined in the interface.
    // The `#[embeddable_as(ERC20)]` attribute gives the component an alias.
    #[embeddable_as(ERC20)]
    impl ERC20Impl<TContractState, +HasComponent<TContractState>> of crate::interfaces::erc20::IERC20<ComponentState<TContractState>>  {

        fn balance_of(self: @ComponentState<TContractState>, address: ContractAddress) -> u256 {
            self.balances.entry(address).read()
        }

        fn total_supply(self: @ComponentState<TContractState>) -> u256 {
            self.supply.read()
        }

        fn transfer(ref self: ComponentState<TContractState>, to: ContractAddress, value: u256) {
           assert(value > 0, 'Value must be greater than 0');
           assert(self.balances.entry(get_caller_address()).read() >= value, 'Not enough balance');
           self._transfer(get_caller_address(), to, value);
        }
    }

    #[generate_trait]
    pub impl ERC20Private<
        TContractState, +HasComponent<TContractState>,
    > of PrivateTrait<TContractState> {

        fn _transfer(ref self:ComponentState<TContractState>, from: ContractAddress, to: ContractAddress, value: u256) {
            let from_balance = self.balances.entry(from).read();
            let to_balance = self.balances.entry(to).read();
            assert(from_balance >= value, 'Not enough balance');
            self.balances.entry(from).write(from_balance - value);
            self.balances.entry(to).write(to_balance + value);
            self.emit(Transfer {
                from: from,
                to: to,
                value: value,
            });
        }

        fn _init(ref self: ComponentState<TContractState>, owner: ContractAddress, name: felt252, decimals: u8, initial_supply: u256, symbol: felt252) {
            self.owner.write(owner);
            self.name.write(name);
            self.symbol.write(symbol);
            self.decimals.write(decimals);
            self.supply.write(initial_supply);
            self.balances.entry(owner).write(initial_supply);
        }
    }
}

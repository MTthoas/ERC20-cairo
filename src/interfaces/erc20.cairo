use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC20<TContractState> {
    fn balance_of(self: @TContractState, address:ContractAddress) -> u256;
    fn total_supply(self: @TContractState) -> u256;
    fn transfer(ref self: TContractState, to: ContractAddress, value: u256);
}
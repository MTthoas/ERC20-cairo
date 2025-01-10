use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC20<TContractState> {
    fn balanceOf(self: @TContractState, address:ContractAddress) -> felt252;
    fn transfer(ref self: TContractState, to: ContractAddress, value: felt252);
    fn totalSupply(self: @TContractState) -> felt252;
}
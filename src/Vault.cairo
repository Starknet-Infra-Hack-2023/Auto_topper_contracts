use starknet::ContractAddress;

#[starknet::interface]
trait IVaultContract<TContractState> {
    fn deposit(ref self: TContractState, token_address: ContractAddress, amount: u256);
}

#[starknet::contract]
mod VaultContract {
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    #[storage]
    struct Storage {
        token_owned: LegacyMap<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DepositSuccess: DepositSuccess,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositSuccess {
        token_address: ContractAddress,
        sender: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    #[external(v0)]
    impl VaultContractImpl of super::IVaultContract<ContractState> {
        fn deposit(ref self: ContractState, token_address: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            IERC20CamelDispatcher { contract_address: token_address }
                .transferFrom(caller, contract_address, amount);
            self.emit(DepositSuccess { token_address: token_address, sender: caller })
        }
    }
}

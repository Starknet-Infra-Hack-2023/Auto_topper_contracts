use starknet::{ContractAddress};
use alexandria_storage::list::{List, ListTrait};

#[starknet::interface]
trait IVaultContract<TContractState> {
    fn deposit(ref self: TContractState, token_address: ContractAddress, amount: u256);
    fn get_funds_customer(ref self: TContractState, token_address: ContractAddress, amount: u256);
    fn withdraw(
        ref self: TContractState,
        token_address: ContractAddress,
        reciever: ContractAddress,
        amount: u256
    );
}

#[derive(Copy, Drop, starknet::Store, Serde, PartialEq)]
enum State {
    PENDING,
    COMPLETED,
}

#[derive(Copy, Drop, starknet::Store, Serde, PartialEq)]
struct CallerQueueStruct {
    caller: ContractAddress,
    token_address: ContractAddress,
    amount: u256,
    state: State,
}

#[starknet::contract]
mod VaultContract {
    use core::option::OptionTrait;
    use core::serde::Serde;
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use super::{CallerQueueStruct, State};
    use alexandria_storage::list::{List, ListTrait};
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};


    #[storage]
    struct Storage {
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DepositSuccess: DepositSuccess,
        CustomerAsk: CustomerAsk,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositSuccess {
        token_address: ContractAddress,
        sender: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct CustomerAsk {
        token_address: ContractAddress,
        sender: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }

    #[external(v0)]
    impl VaultContractImpl of super::IVaultContract<ContractState> {
        fn deposit(ref self: ContractState, token_address: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            IERC20Dispatcher { contract_address: token_address }
                .transfer_from(caller, contract_address, amount);
            self.emit(DepositSuccess { token_address: token_address, sender: caller })
        }

        fn withdraw(
            ref self: ContractState,
            token_address: ContractAddress,
            reciever: ContractAddress,
            amount: u256
        ) {
            assert_is_allowed_user(ref self);
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            IERC20Dispatcher { contract_address: token_address }
                .transfer_from(contract_address, reciever, amount);
        }

        fn get_funds_customer(
            ref self: ContractState, token_address: ContractAddress, amount: u256
        ) {
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            self.emit(CustomerAsk { token_address: token_address, sender: caller });
        }
    }

    fn assert_is_allowed_user(ref self: ContractState) {
        // checks if caller is '123'
        let address = get_caller_address();
        assert(address == self.owner.read(), 'user is not allowed');
    }
}


#[starknet::interface]
trait IActionContract<TContractState> {
    fn action(ref self: TContractState, action: u256);
}


#[starknet::contract]
mod ActionContract {
    #[storage]
    struct Storage {
        state: u256
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ActionStateChange: ActionStateChange
    }

    #[derive(Drop, starknet::Event)]
    struct ActionStateChange {
        state: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    #[external(v0)]
    impl ActionContractImpl of super::IActionContract<ContractState> {
        fn action(ref self: ContractState, action: u256) {
            self.state.write(action);
            self.emit(ActionStateChange { state: self.state.read() });
        }
    }
}

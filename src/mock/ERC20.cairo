use starknet::ContractAddress;

#[starknet::interface]
trait IMockToken<TContractState> {
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256);
}

mod Error {
    const TOKEN_MUST_BE_ABOVE_0: felt252 = 'Token amount must not be 0';
}


#[starknet::contract]
mod MockToken {
    use openzeppelin::token::erc20::ERC20Component;
    use starknet::ContractAddress;
    use super::Error::TOKEN_MUST_BE_ABOVE_0;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20MetadataImpl = ERC20Component::ERC20MetadataImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;
    impl InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let name = 'LORD OF THE TOKENS';
        let symbol = 'LORD';

        self.erc20.initializer(name, symbol);
    }

    #[external(v0)]
    impl MockTokenImpl of super::IMockToken<ContractState> {
        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            // This function is NOT protected which means
            if (amount <= 0) {
                panic(array![TOKEN_MUST_BE_ABOVE_0]);
            }
            // ANYONE can mint tokens
            self.erc20._mint(recipient, amount);
        }
    }
}

// use contracts::Vault::IVaultContractDispatcherTrait;
// use contracts::mock::ERC20::IMockTokenDispatcherTrait;
// use core::result::ResultTrait;
// use starknet::{ContractAddress, get_caller_address};
// use snforge_std::{
//     declare, start_prank, stop_prank, start_mock_call, CheatTarget, ContractClassTrait
// };
// use contracts::{
//     Vault::{VaultContract, IVaultContractDispatcher}, mock::ERC20::{MockToken, IMockTokenDispatcher}
// };
// use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};

// #[test]
// fn deposit_token() {
//     let vault = declare('VaultContract');
//     let address = get_caller_address();
//     let contract_address = vault.deploy(@ArrayTrait::new()).unwrap();
//     let token_address = deploy_token();

//     let tokenDispatcher = IMockTokenDispatcher { contract_address: token_address };
//     let erc20Dispatcher = IERC20CamelDispatcher { contract_address: token_address };
//     let vaultDispatcher = IVaultContractDispatcher { contract_address };

//     let amount: u256 = 1000;
//     start_prank(CheatTarget::One(address), 123.try_into().unwrap());
//     tokenDispatcher.mint(address, 1000);
// // let balance = erc20Dispatcher.balanceOf(address);

// // assert(balance == 1000, 'balance == 1000');
// // vaultDispatcher.deposit(token_address, amount);
// }

// fn deploy_token() -> ContractAddress {
//     let token = declare('MockToken');
//     token.deploy(@ArrayTrait::new()).unwrap()
// }


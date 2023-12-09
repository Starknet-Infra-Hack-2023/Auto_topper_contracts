use contracts::Action::IActionContractDispatcherTrait;
use snforge_std::{
    declare, start_prank, stop_prank, start_mock_call, CheatTarget, ContractClassTrait
};
use contracts::Action::{IActionContractDispatcher, ActionState};

#[test]
fn change_action() {
    let action = declare('ActionContract');
    let contract_address = action.deploy(@ArrayTrait::new()).unwrap();

    let actionDispatcher = IActionContractDispatcher { contract_address };
    actionDispatcher.action(ActionState::DOWN);
}

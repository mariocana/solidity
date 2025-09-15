// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {VaultBase} from "./VaultBase.sol";

library SafeMathLib {
    function safeAdd(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        require(b <= a, "Underflow");
        return a - b;
    }
}

contract VaultManager is VaultBase {

    using SafeMathLib for uint;

    function deposit() external payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        balances[msg.sender] = balances[msg.sender].safeAdd(msg.value);
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] = balances[msg.sender].safeSub(amount);
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

}

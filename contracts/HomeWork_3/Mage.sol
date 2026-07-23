// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WarriorGuild.sol";

contract Mage is WarriorGuild {
    function joinGuild(string memory _name) external {
        _register(_name, "Mage");
    }

    function attack() external override pure returns (string memory, uint256) {
        return ("Chain Lightning (Multi-Target Shock)", 85);
    }
}

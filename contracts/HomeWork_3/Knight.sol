// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WarriorGuild.sol";

contract Knight is WarriorGuild {
    function joinGuild(string memory _name) external {
        _register(_name, "Knight");
    }

    function attack() external override pure returns (string memory, uint256) {
        return ("Holy Smite (Armor Piercing Strike)", 55);
    }
}

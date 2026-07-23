// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WarriorGuild.sol";

contract Assassin is WarriorGuild {
    function joinGuild(string memory _name) external {
        _register(_name, "Assassin");
    }

    function attack() external override pure returns (string memory, uint256) {
        return ("Poison Dart Strike (Damage Over Time)", 110);
    }
}

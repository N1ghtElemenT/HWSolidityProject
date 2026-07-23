// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WarriorGuild {
    struct Warrior {
        string name;
        string subclass;
        bool isRegistered;
    }

    mapping(address => Warrior) public guildMembers;

    function _register(string memory _name, string memory _subclass) internal {
        require(!guildMembers[msg.sender].isRegistered, "Already in guild");
        guildMembers[msg.sender] = Warrior(_name, _subclass, true);
    }

    function attack() external virtual pure returns (string memory, uint256) {
        return ("Fist Strike", 5);
    }
}

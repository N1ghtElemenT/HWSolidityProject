// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../libs/HomeWork_libs3/ResourceUtils.sol";

contract ResourceManager {
    struct Player {
        uint256 energy;
        uint256 gold;
        uint256 level;
    }

    mapping(address => Player) public players;

    function registerPlayer() external {
        require(players[msg.sender].level == 0, "Already registered");
        players[msg.sender] = Player(100, 500, 1);
    }

    function shareEnergy(address[] calldata party, uint256 totalEnergyPool) external {
        uint256 share = ResourceUtils.distributeEnergy(totalEnergyPool, party.length);
        for (uint256 i = 0; i < party.length; i++) {
            players[party[i]].energy += share;
        }
    }

    function upgradeSkills() external {
        Player storage player = players[msg.sender];
        require(player.level > 0, "Register first");

        uint256 multiplier = 150;
        uint256 cost = ResourceUtils.calculateUpgradeCost(player.level, multiplier);
        
        require(player.gold >= cost, "Not enough gold");
        
        player.gold -= cost;
        player.level++;
    }

    function spendAllGoldOnItems(uint256 itemCost) external {
        Player storage player = players[msg.sender];
        require(player.gold >= itemCost, "Can't afford even one");
        uint256 change = ResourceUtils.optimizeGoldSpending(player.gold, itemCost);
        player.gold = change; 
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library ResourceUtils {
    function distributeEnergy(uint totalEnergy, uint playersCount) internal pure returns (uint) {
        require(playersCount > 0, "Players count cannot be zero");
        return totalEnergy / playersCount;
    }

    function calculateUpgradeCost(uint currentLevel, uint multiplier) internal pure returns (uint) {
        return currentLevel * multiplier;
    }

    function optimizeGoldSpending(uint gold, uint cost) internal pure returns (uint) {
        require(cost > 0, "Cost cannot be zero");
        return gold % cost;
    }
}
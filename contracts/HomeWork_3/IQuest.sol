// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IQuest {
    function startQuest(uint256 questId) external;
    function completeQuest(uint256 questId) external;
    function getReward(uint256 questId) external;
}

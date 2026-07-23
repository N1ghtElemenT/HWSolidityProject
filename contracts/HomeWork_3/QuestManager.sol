// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IQuest.sol";

contract QuestManager is IQuest {
    struct Quest {
        uint256 rewardGold;
        uint256 levelRequirement;
        bool exists;
    }

    struct PlayerQuestStatus {
        bool isActive;
        bool isCompleted;
        bool rewardClaimed;
    }

    address public owner;
    mapping(uint256 => Quest) public globalQuests;
    mapping(address => mapping(uint256 => PlayerQuestStatus)) public playerQuests;
    mapping(address => uint256) public playerLevels;
    mapping(address => uint256) public playerGold;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createQuest(uint256 questId, uint256 rewardGold, uint256 levelReq) external onlyOwner {
        globalQuests[questId] = Quest(rewardGold, levelReq, true);
    }

    function startQuest(uint256 questId) external override {
        require(globalQuests[questId].exists, "Quest does not exist");
        
        uint256 currentPlayerLevel = playerLevels[msg.sender] == 0 ? 1 : playerLevels[msg.sender];
        if(playerLevels[msg.sender] == 0) {
            playerLevels[msg.sender] = 1;
        }

        require(currentPlayerLevel >= globalQuests[questId].levelRequirement, "Level too low");
        require(!playerQuests[msg.sender][questId].isActive, "Quest already started");
        require(!playerQuests[msg.sender][questId].isCompleted, "Quest already completed");

        playerQuests[msg.sender][questId].isActive = true;
    }

    function completeQuest(uint256 questId) external override {
        require(playerQuests[msg.sender][questId].isActive, "Quest not started");
        
        playerQuests[msg.sender][questId].isActive = false;
        playerQuests[msg.sender][questId].isCompleted = true;
        playerLevels[msg.sender]++;
    }

    function getReward(uint256 questId) external override {
        require(playerQuests[msg.sender][questId].isCompleted, "Quest not completed");
        require(!playerQuests[msg.sender][questId].rewardClaimed, "Reward already claimed");

        playerQuests[msg.sender][questId].rewardClaimed = true;
        playerGold[msg.sender] += globalQuests[questId].rewardGold;
    }
}

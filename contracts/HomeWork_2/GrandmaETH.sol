// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GrandmaETH {
    address public grandma;
    
    struct Grandchild {
        address payable wallet;
        uint birthdayTimestamp;
        bool hasClaimed;
    }
    
    Grandchild[] public grandchildren;
    uint public totalDeposit;
    bool public isDistributed;

    event DepositMade(address indexed sender, uint amount);
    event GiftClaimed(address indexed grandchild, uint amount);

    constructor() {
        grandma = msg.sender;
    }

    modifier onlyGrandma() {
        require(msg.sender == grandma, "Only grandma can perform this action");
        _;
    }

    modifier notDistributed() {
        require(!isDistributed, "Gifts have already been distributed");
        _;
    }

    function deposit() external payable onlyGrandma notDistributed {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        totalDeposit += msg.value;
        emit DepositMade(msg.sender, msg.value);
    }

    function addGrandchild(address payable _grandchild, uint _birthdayTimestamp) external onlyGrandma notDistributed {
        require(_grandchild != address(0), "Invalid address");
        require(_birthdayTimestamp > 0, "Invalid birthday timestamp");
        grandchildren.push(Grandchild({
            wallet: _grandchild,
            birthdayTimestamp: _birthdayTimestamp,
            hasClaimed: false
        }));
    }

    function claimGift() external {
        require(isDistributed, "Gifts are not yet available");
        uint giftAmount = totalDeposit / grandchildren.length;
        require(giftAmount > 0, "No deposit available");
        
        bool isGrandchild = false;
        for (uint i = 0; i < grandchildren.length; i++) {
            if (grandchildren[i].wallet == msg.sender) {
                isGrandchild = true;
                require(!grandchildren[i].hasClaimed, "Gift already claimed");
                require(block.timestamp >= grandchildren[i].birthdayTimestamp, "Gift not yet available");
                
                grandchildren[i].hasClaimed = true;
                payable(msg.sender).transfer(giftAmount);
                emit GiftClaimed(msg.sender, giftAmount);
                break;
            }
        }
        require(isGrandchild, "Only grandchildren can claim gifts"); 
    }

    function distributeGifts() external onlyGrandma notDistributed {
        require(totalDeposit > 0, "No deposit available");
        require(grandchildren.length > 0, "No grandchildren added");
        isDistributed = true;
    }

    function withdrawRemaining() external onlyGrandma {
        require(isDistributed, "Gifts must be distributed first");
        uint remaining = address(this).balance;
        if (remaining > 0) {
            payable(grandma).transfer(remaining);
        }
    }
}

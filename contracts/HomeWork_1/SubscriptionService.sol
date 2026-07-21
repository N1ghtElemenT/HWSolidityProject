// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionService {
    uint256 public subscriptionPrice;
    uint256 public subscriptionDuration;
    address public owner;

    struct Subscription {
        address user;
        uint256 endTime;
    }

    Subscription[] private subscriptions;
    mapping(address => bool) private isActive;

    constructor(uint256 _price, uint256 _duration) {
        owner = msg.sender;
        subscriptionPrice = _price;
        subscriptionDuration = _duration;
    }

    function subscribe() public payable {
        require(msg.value >= subscriptionPrice, "SubscriptionService: insufficient funds");
        uint256 endTime = block.timestamp + subscriptionDuration;
        subscriptions.push(Subscription(msg.sender, endTime));
        isActive[msg.sender] = true;
    }

    function checkSubscription(address _user) public view returns (bool) {
        for (uint256 i = 0; i < subscriptions.length; i++) {
            if (subscriptions[i].user == _user && subscriptions[i].endTime > block.timestamp) {
                return true;
            }
        }
        return false;
    }

    function updateSubscriptionPrice(uint256 _newPrice) public {
        require(msg.sender == owner, "SubscriptionService: only owner can update price");
        subscriptionPrice = _newPrice;
    }
}
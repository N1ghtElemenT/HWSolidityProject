// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint256 private counter;

    function increment() public {
        counter++;
    }

    function decrement() public {
        require(counter > 0, "Counter: cannot decrement below zero");
        counter--;
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }
}
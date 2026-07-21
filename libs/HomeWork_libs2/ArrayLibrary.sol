// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ArrayLibrary {
    function find(uint[] memory arr, uint value) internal pure returns (int256) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return int256(i);
            }
        }
        return -1;
    }

    function sort(uint[] memory arr) public pure returns (uint[] memory) {
        uint[] memory sortedArr = new uint[](arr.length);
        for (uint i = 0; i < arr.length; i++) {
            sortedArr[i] = arr[i];
        }
        
        for (uint i = 0; i < sortedArr.length - 1; i++) {
            for (uint j = i + 1; j < sortedArr.length; j++) {
                if (sortedArr[i] > sortedArr[j]) {
                    (sortedArr[i], sortedArr[j]) = (sortedArr[j], sortedArr[i]);
                }
            }
        }
        return sortedArr;
    }

    function remove(uint[] memory arr, uint index) internal pure returns (uint[] memory) { // Changed to internal for using for
        require(index < arr.length, "Index out of bounds");
        uint[] memory newArr = new uint[](arr.length - 1);
        
        for (uint i = 0; i < index; i++) {
            newArr[i] = arr[i];
        }
        
        for (uint i = index + 1; i < arr.length; i++) {
            newArr[i - 1] = arr[i];
        }
        
        return newArr;
    }
}
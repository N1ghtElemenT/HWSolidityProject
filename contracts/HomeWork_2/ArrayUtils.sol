// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../libs/HomeWork_libs2/ArrayLibrary.sol";

contract ArrayUtils {
    using ArrayLibrary for uint[];

    function testFind(uint[] memory arr, uint value) public pure returns (int256) {
        return arr.find(value);
    }

    function testSort(uint[] memory arr) public pure returns (uint[] memory) {
        return arr.sort();
    }

    function testRemove(uint[] memory arr, uint index) public pure returns (uint[] memory) {
        return arr.remove(index);
    }
}
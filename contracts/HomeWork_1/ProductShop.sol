// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductShop {
    struct Product {
        string name;
        uint256 price;
    }

    Product[] private products;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string memory _name, uint256 _price) public {
        require(msg.sender == owner, "ProductShop: only owner can add products");
        products.push(Product(_name, _price));
    }

    function buyProduct(uint256 _index) public payable {
        require(_index < products.length, "ProductShop: product does not exist");
        require(msg.value >= products[_index].price, "ProductShop: insufficient funds");
        payable(owner).transfer(products[_index].price);
    }

    function getProducts() public view returns (Product[] memory) {
        return products;
    }
}
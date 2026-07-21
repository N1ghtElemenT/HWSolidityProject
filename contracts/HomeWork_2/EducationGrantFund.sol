// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationGrantFund {
    address public owner;
    uint public totalFund;
    
    struct Student {
        address payable wallet;
        uint depositAmount;
        bool isEligible;
        bool isClaimed;
    }

    Student[] public students;
    mapping(address => bool) public isStudent;

    event DepositMade(address indexed sender, uint amount);
    event GrantClaimed(address indexed student, uint amount);
    event EligibilityConfirmed(address indexed student, bool isEligible);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyStudent() {
        require(isStudent[msg.sender], "Only students can perform this action");
        _;
    }

    function addStudent(address payable _student) external onlyOwner {
        require(!isStudent[_student], "Student already exists");
        students.push(Student({
            wallet: _student,
            depositAmount: 0,
            isEligible: false,
            isClaimed: false
        }));
        isStudent[_student] = true;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        totalFund += msg.value;
        emit DepositMade(msg.sender, msg.value);
    }

    function confirmEligibility(address _student) external onlyOwner {
        for (uint i = 0; i < students.length; i++) {
            if (students[i].wallet == _student) {
                students[i].isEligible = true;
                emit EligibilityConfirmed(_student, true);
                break;
            }
        }
    }

    function claimGrant() external onlyStudent {
        for (uint i = 0; i < students.length; i++) {
            if (students[i].wallet == msg.sender) {
                require(students[i].isEligible, "Student is not eligible");
                require(!students[i].isClaimed, "Grant already claimed");
                require(totalFund > 0, "No funds available");
                
                uint grantAmount = 1 ether;
                require(totalFund >= grantAmount, "Insufficient funds for grant");
                
                students[i].isClaimed = true;
                totalFund -= grantAmount;
                payable(msg.sender).transfer(grantAmount);
                emit GrantClaimed(msg.sender, grantAmount);
                break;
            }
        }
    }
}

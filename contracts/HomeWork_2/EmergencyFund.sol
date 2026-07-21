// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmergencyFund {
    address public owner;
    address[] public participants;
    mapping(address => uint) public contributions;
    mapping(address => bool) public isParticipant;
    
    uint public requiredConfirmations;
    
    struct Confirmation {
        address[] confirmators;
        mapping(address => bool) hasConfirmed;
    }
    mapping(address => Confirmation) private confirmations;
    mapping(address => bool) public hasClaimed;

    event DepositMade(address indexed participant, uint amount);
    event EmergencyClaimed(address indexed participant, uint amount);
    event ConfirmationAdded(address indexed confirmator, address indexed participant);

    constructor(uint _requiredConfirmations) {
        owner = msg.sender;
        requiredConfirmations = _requiredConfirmations;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyParticipant() {
        require(isParticipant[msg.sender], "Only participants can perform this action");
        _;
    }

    function addParticipant(address _participant) external onlyOwner {
        require(!isParticipant[_participant], "Participant already exists");
        participants.push(_participant);
        isParticipant[_participant] = true;
    }

    function deposit() external payable onlyParticipant {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        contributions[msg.sender] += msg.value;
        emit DepositMade(msg.sender, msg.value);
    }

    function confirmEmergency(address _participant) external onlyParticipant {
        require(isParticipant[_participant], "Not a participant");
        require(!confirmations[_participant].hasConfirmed[msg.sender], "Already confirmed");
        confirmations[_participant].confirmators.push(msg.sender);
        confirmations[_participant].hasConfirmed[msg.sender] = true;
        emit ConfirmationAdded(msg.sender, _participant);
    }

    function claimEmergencyFund() external onlyParticipant {
        require(!hasClaimed[msg.sender], "Already claimed");
        
        uint confirmationCount = confirmations[msg.sender].confirmators.length;
        require(confirmationCount >= requiredConfirmations, "Insufficient confirmations");
        
        uint totalFunds = address(this).balance;
        require(totalFunds > 0, "No funds available");
        
        uint amount = contributions[msg.sender];
        payable(msg.sender).transfer(amount);
        hasClaimed[msg.sender] = true;
        confirmations[msg.sender].confirmators = new address[](0);
        emit EmergencyClaimed(msg.sender, amount);
    }

    function resetConfirmations(address _participant) external onlyOwner {
        for (uint i = 0; i < confirmations[_participant].confirmators.length; i++) {
            address confirmer = confirmations[_participant].confirmators[i];
            confirmations[_participant].hasConfirmed[confirmer] = false;
        }

        delete confirmations[_participant].confirmators;
    }
}

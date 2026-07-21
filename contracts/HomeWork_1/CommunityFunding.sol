// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunityFunding {
    struct Project {
        string description;
        uint256 requiredAmount;
        uint256 voteCount;
        address creator;
    }

    Project[] private projects;
    mapping(address => mapping(uint256 => bool)) private hasVoted;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function proposeProject(string memory _description, uint256 _requiredAmount) public {
        projects.push(Project(_description, _requiredAmount, 0, msg.sender));
    }

    function voteForProject(uint256 _index) public {
        require(_index < projects.length, "CommunityFunding: project does not exist");
        require(!hasVoted[msg.sender][_index], "CommunityFunding: already voted for this project");
        hasVoted[msg.sender][_index] = true;
        projects[_index].voteCount++;
    }

    function distributeFunds() public payable {
        require(msg.sender == owner, "CommunityFunding: only owner can distribute funds");
        uint256 totalVotes = 0;
        for (uint256 i = 0; i < projects.length; i++) {
            totalVotes += projects[i].voteCount;
        }

        require(totalVotes > 0, "CommunityFunding: no votes cast");

        for (uint256 i = 0; i < projects.length; i++) {
            if (projects[i].voteCount > 0) {
                uint256 amount = (msg.value * projects[i].voteCount) / totalVotes;
                payable(projects[i].creator).transfer(amount);
            }
        }
    }

    function getProjects() public view returns (Project[] memory) {
        return projects;
    }
}
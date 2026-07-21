// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] private candidates;
    mapping(address => bool) private hasVoted;

    function addCandidate(string memory _name) public {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint256 _index) public {
        require(_index < candidates.length, "VotingSystem: candidate does not exist");
        require(!hasVoted[msg.sender], "VotingSystem: already voted");
        hasVoted[msg.sender] = true;
        candidates[_index].voteCount++;
    }

    function getResults() public view returns (Candidate[] memory) {
        return candidates;
    }
}
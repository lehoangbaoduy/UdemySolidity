// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Lottery {
    address public manager;
    address[] public players;

    // make sure that the person who deploys this contract is manager
    constructor () {
        manager = msg.sender;
    }
    
    // if you want to enter the lotter
    // you will have to pay money
    function enter() public payable {
        // require() is used for validation
        // parameter is bool expression 
        // if true => code inside the function runs as usual
        // if false => entire function immediate exit & no changes are made
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    // pick winner by taking big generated random number % players array length => index of win player
    function pickWinner() public restricted{
        // attempt to detect the person trying to call this function is a manager
        require(msg.sender == manager);

        uint index = random() % players.length;
        // transfer(): will attempt to take some amount of money from current cortract and send it to players[index]
        // this.balance: all amount of current contract
        payable(players[index]).transfer(address(this).balance);

        // new dynamic array with initial size of 0
        players = new address[](0);
    }

    // function modifiers
    // solidity will take all the code out of function
    // then place it in the "_"
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery{

    // entities : manager , player and winner

    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){

        manager = msg.sender;

    }


    function participate() public payable {

        require(msg.value >= 1, "The minimum amount to enter is 1 ETH only.");
        players.push(payable (msg.sender));

    }

    function getBalance() public view returns(uint256){

        require(manager == msg.sender, "You are not the manager.");
        return address(this).balance;

    }

    function random() public view returns(uint256){

        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));

    }


    function pickWinner() public{

        require(manager == msg.sender, "You are not the manager.");
        require(players.length >= 3, "Players are length than 3.");

        uint256 randomNumber = random();
        uint256 index = randomNumber % players.length; // no o/p will always be less than players.length
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0); // this will initialize the players array back to 0

    }

}
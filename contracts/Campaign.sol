pragma solidity ^0.8.9;

contract Campaign {
    address public manager;
    uint public minimumContribution;

    Campaign(uint minimum){
        manager = msg.sender;
        minimumContribution = minimum;
    }
}
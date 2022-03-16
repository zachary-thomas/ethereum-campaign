pragma solidity ^0.8.9;

contract Campaign {
    address public manager;
    uint public minimumContribution;
    address[] public approvers;
    

    constructor (uint minimum){
        manager = msg.sender;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers.push(msg.sender);
    }

}
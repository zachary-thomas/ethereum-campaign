pragma solidity ^0.8.9;

contract Campaign {

    // Struct type
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        // People that approved the request
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    //address[] public approvers;

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    constructor (uint minimum){
        manager = msg.sender;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        // only stores the boolean
        approvers[msg.sender] = true;

        // old way with array
        //approvers.push(msg.sender);
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
        // Sees if person contributed
        // require(approvers[msg.sender]);

        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false
        });

        // Alternitive
        // Request(description, value, recipient, false);

        requests.push(newRequest);
    }

}
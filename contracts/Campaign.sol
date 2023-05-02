pragma solidity ^0.8.9;

contract CampaignFactory{
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public{
        // Need to send in user address
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns(address[] memory){
        return deployedCampaigns;
    }
}


contract Campaign {

    // Struct type
    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        // People that approved the request
        // Reference types don't need to be created below
        mapping(address => bool) approvals;
    }

    uint numRequests;
    mapping (uint => Request) public requests;
    uint public approversCount;

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    //address[] public approvers;

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    constructor (uint minimum, address creator){
        // Before factory, which would set the
        // address to the factory contract
        // manager = msg.sender;
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        // only stores the boolean
        approvers[msg.sender] = true;
        approversCount++;

        // old way with array
        //approvers.push(msg.sender);
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
        // Sees if person contributed
        // require(approvers[msg.sender]);

        // In old version of solidity
        // Request memory newRequest = Request({
        //     description: description,
        //     value: value,
        //     recipient: recipient,
        //     complete: false,
        //     approvalCount: 0
        // });

        Request storage r = requests[numRequests++];
        r.description = description;
        r.value = value;
        r.recipient = recipient;
        r.complete = false;
        r.approvalCount = 0;

        // Alternitive
        // Request(description, value, recipient, false);
        //requests.push(newRequest);
    }

    function approveRequest(uint index) public{
        // References real storage in contract
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        // We want the approval to go through if they
        // have not approved before
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        // Require 50% approval
        require(request.approvalCount > (approversCount / 2));

        // Campaign is done
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getRequest(uint index) public view returns(string memory description, 
        uint value, 
        address recipient,
        bool complete,
        uint approvalCount ) {

            Request storage request = requests[index];
            return (request.description, 
                request.value, 
                request.recipient, 
                request.complete, 
                request.approvalCount);
    }
}
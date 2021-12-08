// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

contract Ticket {
    // State Variables
    mapping (address => uint256) public ticketHolders;
    uint256 public ticketCost = 0.5 ether;
    address owner;

    constructor() {
        owner = msg.sender;     
    }
        
    function buyTicket(address _user, uint256 _amount) payable public {
        require(msg.value >= ticketCost * _amount, "Insufficient funds to purchase tickets.");
        addTicket(_user, _amount);
    }

    function useTicket(address _user, uint256 _amount) public {
        require(_amount >= 1, "You must use at least 1 ticket.");
        subtractTicket(_user, _amount);
    }

    function addTicket(address _user, uint256 _amount) internal {
        ticketHolders[_user] = ticketHolders[_user] + _amount;
    }

    function subtractTicket(address _user, uint256 _amount) internal {
        require(ticketHolders[_user] >= _amount, "You do not have enough tickets.");
        ticketHolders[_user] = ticketHolders[_user] - _amount;
    }

    function withdraw() public {
        require(msg.sender == owner, "You are not the owner.");
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AnalyticsAndReporting is ERC721, Ownable {
    uint256 public totalTicketsSold;
    uint256 public totalRevenue;

    constructor() ERC721("AnalyticsAndReporting", "ANRP") {}

    function buyTicket(uint256 ticketId, uint256 price) public payable {
        // Check that the buyer sent enough Ether
        require(msg.value == price, "Incorrect price");

        // Transfer the Ether to the contract owner
        payable(owner()).transfer(msg.value);

        // Transfer the ticket to the buyer
        _transfer(address(this), msg.sender, ticketId);

        // Update the analytics
        totalTicketsSold++;
        totalRevenue += price;
    }

    function getAnalytics() public view returns (uint256, uint256) {
        return (totalTicketsSold, totalRevenue);
    }
}

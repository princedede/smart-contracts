// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AdditionalFeatures is ERC721, Ownable {
    struct Ticket {
        uint256 eventId;
        uint256 price;
    }

    Ticket[] public tickets;

    constructor() ERC721("AdditionalFeatures", "AFTR") {}

    function transferTicket(address to, uint256 ticketId) public {
        // Check that the sender is the owner of the ticket
        require(ownerOf(ticketId) == msg.sender, "You do not own this ticket");

        // Transfer the ticket
        _transfer(msg.sender, to, ticketId);
    }

    function buyTickets(uint256[] memory ticketIds) public payable {
        uint256 totalCost = 0;

        // Calculate the total cost of the tickets
        for (uint i = 0; i < ticketIds.length; i++) {
            totalCost += tickets[ticketIds[i]].price;
        }

        // Check that the buyer sent enough Ether
        require(msg.value == totalCost, "Incorrect price");

        // Transfer the tickets
        for (uint i = 0; i < ticketIds.length; i++) {
            _transfer(address(this), msg.sender, ticketIds[i]);
        }
    }
}

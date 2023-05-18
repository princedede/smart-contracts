// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract EventManagement is ERC721Enumerable, Ownable {
    struct Event {
        string name;
        uint256 ticketPrice;
        uint256 totalTickets;
        uint256 ticketsSold;
    }

    Event[] public events;

    constructor() ERC721("EventManagement", "EMGT") {}

    function createEvent(
        string memory _name,
        uint256 _ticketPrice,
        uint256 _totalTickets
    ) public onlyOwner {
        events.push(
            Event({
                name: _name,
                ticketPrice: _ticketPrice,
                totalTickets: _totalTickets,
                ticketsSold: 0
            })
        );
    }

    function buyTicket(uint256 _eventId) public payable {
        // Check that the event exists
        require(_eventId < events.length, "Event does not exist");

        // Check that there are still tickets available
        require(
            events[_eventId].ticketsSold < events[_eventId].totalTickets,
            "No tickets available"
        );

        // Check that the buyer sent enough Ether
        require(msg.value == events[_eventId].ticketPrice, "Incorrect price");

        // Mint a new ticket and transfer it to the buyer
        uint256 ticketId = totalSupply() + 1;
        _mint(msg.sender, ticketId);

        // Update the event
        events[_eventId].ticketsSold++;
    }
}

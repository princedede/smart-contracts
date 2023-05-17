// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketMarketplace is ERC721, Ownable {
    struct TicketForSale {
        uint256 ticketId;
        address seller;
        uint256 price;
    }

    TicketForSale[] public ticketsForSale;

    constructor() ERC721("TicketMarketplace", "TMKT") {}

    function listTicketForSale(uint256 _ticketId, uint256 _price) public {
        // Transfer the ticket to the contract
        transferFrom(msg.sender, address(this), _ticketId);

        // Add the ticket to the ticketsForSale array
        ticketsForSale.push(
            TicketForSale({
                ticketId: _ticketId,
                seller: msg.sender,
                price: _price
            })
        );
    }

    function buyTicket(uint256 _ticketId) public payable {
        // Find the ticket in the ticketsForSale array
        for (uint i = 0; i < ticketsForSale.length; i++) {
            if (ticketsForSale[i].ticketId == _ticketId) {
                // Check that the buyer sent enough Ether
                require(
                    msg.value == ticketsForSale[i].price,
                    "Incorrect price"
                );

                // Transfer the Ether to the seller
                payable(ticketsForSale[i].seller).transfer(msg.value);

                // Transfer the ticket to the buyer
                _transfer(address(this), msg.sender, _ticketId);

                // Remove the ticket from the ticketsForSale array
                ticketsForSale[i] = ticketsForSale[ticketsForSale.length - 1];
                ticketsForSale.pop();

                return;
            }
        }

        revert("Ticket not found");
    }
}

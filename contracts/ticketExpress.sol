// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketExpress is ERC721, Ownable {
    uint256 public ticketId;
    mapping (uint256 => address) public ticketOwner;
    mapping (uint256 => uint256) public ticketPrice;

    constructor() ERC721("TicketExpress", "TICK") {}

    function mintTicket(address to, uint256 price) public onlyOwner {
        ticketId++;
        _mint(to, ticketId);
        ticketOwner[ticketId] = to;
        ticketPrice[ticketId] = price;
    }

    function buyTicket(uint256 _ticketId) public payable {
        require(msg.value == ticketPrice[_ticketId], "Incorrect price");
        address owner = ticketOwner[_ticketId];
        payable(owner).transfer(msg.value);
        _transfer(owner, msg.sender, _ticketId);
        ticketOwner[_ticketId] = msg.sender;
    }
}

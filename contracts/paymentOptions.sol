// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PaymentOptions is ERC721, Ownable {
    IERC20 public token;

    constructor(address _token) ERC721("PaymentOptions", "POPT") {
        token = IERC20(_token);
    }

    function depositTokens(uint256 amount) public {
        // Transfer the tokens from the sender to this contract
        token.transferFrom(msg.sender, address(this), amount);
    }

    function buyTicket(uint256 ticketId, uint256 price) public {
        // Check that the sender has enough tokens
        require(token.balanceOf(msg.sender) >= price, "Not enough tokens");

        // Transfer the tokens from the sender to this contract
        token.transferFrom(msg.sender, address(this), price);

        // Transfer the ticket to the sender
        _transfer(address(this), msg.sender, ticketId);
    }
}

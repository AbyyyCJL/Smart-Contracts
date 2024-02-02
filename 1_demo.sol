// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract EventContract{

    struct Event{

        address organiser;
        string name;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemain;
    }

    mapping (uint256 => Event) public events;
    mapping (address => mapping(uint256 => uint256)) public tickets;

    uint256 public nextId = 0;

    function createEvent(string memory name, uint256 date, uint256 price, uint256 ticketCount) public {

        require(date > block.timestamp, "Event has passed.");
        require(ticketCount > 0, "Tickets must be there to organize events.");

        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount);
        nextId++;

    }


    function buyTicket(uint256 id, uint256 quantity) public payable{

        require(events[id].date != 0, "Event event does not exist.");
        require(events[id].date > block.timestamp, "Event has already occured.");

        Event storage _event = events[id];

        require(msg.value == (_event.price * quantity), "Ether is not Enough.");
        require(_event.ticketRemain > quantity, "Not enough Tickets.");

        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;

    }

    function transferTicket(uint256 eventId, uint256 quantity, address to) external {

        require(events[eventId].date != 0, "Event event does not exist.");
        require(events[eventId].date > block.timestamp, "Event has already occured.");
        require(tickets[msg.sender][eventId] >= quantity, "You do not have enough tickets.");
        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId] += quantity;

    }


}
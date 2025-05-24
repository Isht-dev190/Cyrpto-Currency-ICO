// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Auction {
    address payable public owner;
    uint256 public start;
    uint256 public end;
    bool public canceled;
    bool public ended;

    mapping(address => uint256) bids;
    address payable public highestBidder;
    uint256 public highestBid;
    uint256 public highestBindingBid;
    uint256 public increment;

    event BidPlaced(address bidder, uint256 amount);
    event AuctionCanceled();
    event AuctionFinalized(address winner, uint256 amount);


    constructor(uint256 startAt, uint256 endAt, uint256 _increment) {
        require(startAt < endAt, "Invalid times");
        owner = payable(msg.sender);
        start = startAt;
        end = endAt;
        increment = _increment;
    }

    function placeBid() public payable {
        bids[msg.sender] += msg.value;
        uint256 currentBid = bids[msg.sender];
        
        require(currentBid >= highestBindingBid + increment, "Bid is too low");

        uint256 previousHighestBid = highestBid;
        address payable previousHighestBidder = highestBidder;

        highestBidder = payable(msg.sender);
        highestBid = currentBid;
        highestBindingBid += increment;

        if (previousHighestBidder != address(0)) {
            bids[previousHighestBidder] -= previousHighestBid;
            previousHighestBidder.transfer(previousHighestBid);
        }

        emit BidPlaced(msg.sender, currentBid);
    }
    function cancelAuction() external {
        require(msg.sender == owner, "Not owner");
        require(!canceled, "Already canceled");
        canceled = true;
        emit AuctionCanceled();
        }

    function finalizeAuction() external  {
        require(msg.sender == owner, "Not owner");
        require(block.timestamp > end || canceled, "Auction not ended");
        require(!ended, "Already ended");
        ended = true;

        if (highestBidder != address(0)) {
            owner.transfer(highestBindingBid);
        }
        emit AuctionFinalized(highestBidder, highestBindingBid);
    }

    function withdraw() external {
            require(ended || canceled, "Auction not ended");
            uint256 amount = bids[msg.sender];
            require(amount > 0, "Nothing to withdraw");
            bids[msg.sender] = 0;
            (bool success, ) = msg.sender.call{value: amount}("");
            require(success, "Transfer failed");
        }
  


}
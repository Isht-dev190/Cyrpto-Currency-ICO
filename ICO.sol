// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import './myCoin.sol';

contract MyICO {
    MYCoin public token;
    uint public startTimeICO;
    uint public endTimeICO;
    uint public constant PRICE = 0.001 ether; 
    uint public constant MIN_INVESTMENT = 0.01 ether; 
    address public owner;
    
    bool public icoActive;
    uint public totalRaised;
    
    event InvestmentMade(address indexed investor, uint ethAmount, uint tokenAmount);
    event RefundIssued(address indexed investor, uint amount);
    event ICOStarted(uint startTime, uint endTime);
    event ICOEnded();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(address _tokenAddress) {
        token = MYCoin(_tokenAddress);
        owner = msg.sender;
    }

    function startICO(uint _duration) public onlyOwner {
        require(token.balanceOf(address(this)) > 0, "No tokens in ICO");
        icoActive = true;
        startTimeICO = block.timestamp;
        endTimeICO = block.timestamp + _duration;
        emit ICOStarted(startTimeICO, endTimeICO);
    }

    function invest() public payable {
        require(icoActive, "ICO not active");
        require(block.timestamp <= endTimeICO, "ICO ended");
        require(msg.value >= MIN_INVESTMENT, "Below minimum");

        uint tokensToBuy = (msg.value * 1e18) / PRICE;
        uint contractBalance = token.balanceOf(address(this));
        
        if (tokensToBuy > contractBalance) {
            payable(msg.sender).transfer(msg.value);
            emit RefundIssued(msg.sender, msg.value);
            return;
        }

        token.transfer(msg.sender, tokensToBuy);
        totalRaised += msg.value;
        emit InvestmentMade(msg.sender, msg.value, tokensToBuy);
    }

    receive() external payable {
        invest();
    }

    function endICO() public onlyOwner {
        icoActive = false;
        emit ICOEnded();
    }
}
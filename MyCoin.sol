// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import './ERC20Interface.sol';

contract MYCoin {
    string public name = "Previx";
    string public symbol = "PRV";
    uint public totalSupply;
    uint public decimals = 18;
    address public founder;

    mapping(address => uint) public balances;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event BalanceChecked(address indexed account, uint balance);

    constructor() {
        totalSupply = 1000 * (10 ** decimals);
        founder = msg.sender;
        balances[founder] = totalSupply;
        emit Transfer(address(0), founder, totalSupply);
    }

    function balanceOf(address account) public view returns (uint) {
        return balances[account];
    }

    function transfer(address to, uint value) public returns (bool) {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function checkBalance(address account) public returns (uint) {
        uint balance = balanceOf(account); 
        emit BalanceChecked(account, balance);
        return balance;
    }
}
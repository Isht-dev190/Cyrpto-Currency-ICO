// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function transfer(address to, uint tokens) external returns(bool success);
    function balanceOf(address tokenOwner) external view returns (uint balance);

    event Transfer(address indexed from, address indexed to, uint tokens);
}

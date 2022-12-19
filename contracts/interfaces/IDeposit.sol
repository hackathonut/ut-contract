// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

interface IDeposit {

    function deposit(address token, uint256 amount) external;
}
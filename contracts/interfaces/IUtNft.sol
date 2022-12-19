// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

interface IUtNft {
    function mint(address user, address token, uint256 amount) external;
}
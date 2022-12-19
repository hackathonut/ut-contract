// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IUtNft.sol";

contract Deposit is Ownable {

    mapping(address => bool) public whitelistToken;
    mapping(address => bool) public cexAddressList;
    mapping(address => bool) public withdrawTriggerList;

    IUtNft public utNft;

    // EVENTS
    event Deposited(address user, address token, uint256 amount);
    event TokenWithdrawn(address token, address cexAddress, uint256 amount);
    event WhitelistTokenAdded(address token);
    event WhitelistTokenRemoved(address token);
    event CexAddressAdded(address token);
    event CexAddressRemoved(address token);
    event WithdrawTriggerAdded(address trigger);
    event WithdrawTriggerRemoved(address trigger);

    modifier onlyWithdrawTigger() {
        require(withdrawTriggerList[msg.sender], "Not called from nft contract");
        _;
    }

    function deposit(address token, uint256 amount) external payable{
        require(whitelistToken[token], "Not whitelisted token");
        require(amount > 0, "Amount is zero");

        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // mint
        utNft.mint(msg.sender, token, amount);

        emit Deposited(msg.sender, token, amount);
    }

    function withdrawTokenToCex(address token, address cexAddress, uint256 amount) public onlyWithdrawTigger {
        require(whitelistToken[token], "Not whitelisted token");
        require(cexAddressList[cexAddress], "Not registered cex address");
        uint256 balance = IERC20(token).balanceOf(address(this));
        amount = amount > balance ? balance : amount;
        require(amount > 0, "Token balance or amount is zero");

        IERC20(token).transfer(cexAddress, amount);
        emit TokenWithdrawn(token, cexAddress, amount);
    }

    function addWhitelistedToken(address token) public onlyOwner {
        require(!whitelistToken[token], "Already added");
        whitelistToken[token] = true;
        emit WhitelistTokenAdded(token);
    }

    function removeWhitelistToken(address token) public onlyOwner {
        require(whitelistToken[token], "Already removed");
        whitelistToken[token] = false;
        emit WhitelistTokenRemoved(token);
    }

    function addCexAddress(address cexAddress) public onlyOwner {
        require(!cexAddressList[cexAddress], "Already added");
        cexAddressList[cexAddress] = true;
        emit CexAddressAdded(cexAddress);
    }

    function removeCexAddress(address cexAddress) public onlyOwner {
        require(cexAddressList[cexAddress], "Already removed");
        cexAddressList[cexAddress] = false;
        emit CexAddressRemoved(cexAddress);
    }

    function addWithdrawTrigger(address trigger) public onlyOwner {
        require(!withdrawTriggerList[trigger], "Already added");
        cexAddressList[trigger] = true;
        emit WithdrawTriggerAdded(trigger);
    }

    function removeWithdrawTrigger(address trigger) public onlyOwner {
        require(withdrawTriggerList[trigger], "Already removed");
        cexAddressList[trigger] = false;
        emit WithdrawTriggerRemoved(trigger);
    }

    function setUtNft(IUtNft utNft_) public onlyOwner {
        require(address(utNft_) != address(0), "Address is zero");
        utNft = utNft_;
    }
}
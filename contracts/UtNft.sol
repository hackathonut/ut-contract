// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract UtNft is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    struct DepositInfo {
        address token;
        uint256 amount;
        uint256 debt;
    }

    mapping(uint256 => DepositInfo) public depositInfos;
    mapping(address => uint256) public totalDepositAmount;
    mapping(address => uint256) public claimInfo;

    address public utDepositContract;

    event Claimed(address indexed user, uint256 indexed tokenId, uint256 indexed amount);
    event Redeemed(address indexed user, uint256 indexed tokenId);


    constructor() ERC721("Unstable Treasury NFT", "UT NFT") {

    }

    modifier onlyDepositContract() {
        require(msg.sender == utDepositContract, "Not called from deposit contract");
        _;
    }

    function pendingReward(uint256 tokenId) public view returns(uint256) {
        address _token = depositInfos[tokenId].token;
        uint256 pending = (depositInfos[tokenId].amount * claimInfo[_token] / 1e12) - depositInfos[tokenId].debt;
        return pending;
    }

    function mint(address user, address token, uint256 amount) external onlyDepositContract {
        require(user != address(0), "User cant be zero addr");
        require(token != address(0), "Token cant be zero addr");
        require(amount != 0, "Amount can not be zero");

        uint256 _tokenId = _tokenIds.current();
        uint256 _debt = amount * claimInfo[token] / 1e12;

        depositInfos[_tokenId] = DepositInfo(token,amount, _debt);
        _tokenIds.increment();
        totalDepositAmount[token] += amount;

        _safeMint(user, _tokenId);
    }

    // nonreentrancy ??
    function claim(uint256 tokenId) public nonReentrant {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        address _token = depositInfos[tokenId].token;

        uint256 pending = (depositInfos[tokenId].amount * claimInfo[_token] / 1e12) - depositInfos[tokenId].debt;
        if (pending > 0) {
            IERC20(_token).transfer(msg.sender, pending);
            depositInfos[tokenId].debt = depositInfos[tokenId].amount * claimInfo[_token] / 1e12;
            emit Claimed(msg.sender, tokenId, pending);
        }
    }

    function redeem(uint256 tokenId) public {
        claim(tokenId);
        
        totalDepositAmount[depositInfos[tokenId].token] -= depositInfos[tokenId].amount;

        _burn(tokenId);

        delete depositInfos[tokenId];
        emit Redeemed(msg.sender, tokenId);  
    }

    function setDepositContract(address deposit_) public onlyOwner {
        require(deposit_ != address(0), "Address is zero");
        utDepositContract = deposit_;
    }

    function addInterestAmount(address token, uint256 amount, uint256 latestClaimableRound) public onlyOwner {
        require(token != address(0), "Token cant be zero addr");
        claimInfo[token] += amount * 1e12 / totalDepositAmount[token];
    }

    function _baseURI() internal view override returns (string memory) {
        return ""; // common uri 넣기
    }
}
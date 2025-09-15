// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./TicketNFT.sol";
import "./BananaNFT.sol";
import "./MockUSDC.sol";


contract CrazySuitcase is Ownable, ReentrancyGuard {
    uint256 public constant SUITCASE_PRICE = 0.00025 ether;

    uint256 private _nextTicketTokenId;
    uint256 private _nextBananaTokenId;
    
    // Prize tokens
    MockUSDC public usdcToken;
    TicketNFT public ticketNFT;
    BananaNFT public bananaNFT;
    
    // Prize probabilities (out of 100)
    uint256 public USDC_PROBABILITY = 5;  // 50%
    uint256 public TICKET_PROBABILITY = 45; // 30%
    uint256 public BANANA_PROBABILITY = 50; // 20%
    
    // Prize amounts
    uint256 public constant USDC_AMOUNT = 10 * 10**6; // 10 USDC (6 decimals)
    
    // Events
    event SuitcasePurchased(address indexed buyer, uint256 prizeType, uint256 amount);
    event PrizeDistributed(address indexed winner, string prizeType, uint256 amount);
    
    // Prize types
    enum PrizeType { USDC, TICKET_NFT, BANANA_NFT }
    
    constructor(
        address _usdcToken,
        address _ticketNFT,
        address _bananaNFT
    ) Ownable(msg.sender) {
        usdcToken = MockUSDC(_usdcToken);
        ticketNFT = TicketNFT(_ticketNFT);
        bananaNFT = BananaNFT(_bananaNFT);
    }
    
    function buySuitcase() external payable nonReentrant {        
        // Generate random number for prize selection
        uint256 randomNum = _generateRandomNumber() % 100;
        PrizeType prizeType;
        
        if (randomNum < USDC_PROBABILITY) {
            prizeType = PrizeType.USDC;
            _distributeUSDC(msg.sender);
        } else if (randomNum < USDC_PROBABILITY + TICKET_PROBABILITY) {
            prizeType = PrizeType.TICKET_NFT;
            _distributeTicketNFT(msg.sender);
        } else {
            prizeType = PrizeType.BANANA_NFT;
            _distributeBananaNFT(msg.sender);
        }
        
        emit SuitcasePurchased(msg.sender, uint256(prizeType), SUITCASE_PRICE);
    }
    
    function _distributeUSDC(address winner) internal {
        require(usdcToken.balanceOf(address(this)) >= USDC_AMOUNT, "Insufficient USDC balance");
        usdcToken.transfer(winner, USDC_AMOUNT);
        emit PrizeDistributed(winner, "Mock USDC", USDC_AMOUNT);
    }
    
    function _distributeTicketNFT(address winner) internal {
        ticketNFT.mint(winner); 

        emit PrizeDistributed(winner, "TicketNFT", 1);
    }
    
    function _distributeBananaNFT(address winner) internal {        
        bananaNFT.mint(winner); 

        emit PrizeDistributed(winner, "BananaNFT", 1);
    }
    
    function _generateRandomNumber() internal view returns (uint256) {
        // Simple pseudo-random number generation
        // In production, use Chainlink VRF for true randomness
        return uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender,
            blockhash(block.number - 1)
        )));
    }
    
    // Owner functions
    function withdrawETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    function depositUSDC(uint256 amount) external onlyOwner {
        usdcToken.transferFrom(msg.sender, address(this), amount);
    }
    
    function emergencyWithdrawUSDC() external onlyOwner {
        uint256 balance = usdcToken.balanceOf(address(this));
        usdcToken.transfer(owner(), balance);
    }

    function editProbability(uint256 usdcProb, uint256 ticketProb, uint256 bananaProb) external onlyOwner {
        USDC_PROBABILITY = usdcProb;
        TICKET_PROBABILITY = ticketProb;
        BANANA_PROBABILITY = bananaProb;
    }
    
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function getUSDCBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }
}

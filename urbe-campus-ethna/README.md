# Contracts for [Suitacases MiniApp](https://github.com/marcanalella/crazy-suitcase)

# How to Use
# Deploy Contracts on Base Sepolia
1. Get Base Sepolia ETH: Go to https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet
2. Deploy in Remix IDE:
    - Go to https://remix.ethereum.org
    - Copy your .sol files from contracts/ folder
    -   Deploy in this order:   
        1. MockUSDC.sol
        2. TicketNFT.sol
        3. BananaNFT.sol
        4. CrazySuitcase.sol (with the other 3 addresses as constructor params)

3. Update addresses: Replace the addresses in lib/contracts.ts with your deployed addresses
4. Setup permissions:
    - Transfer ownership of NFT contracts to CrazySuitcase
    - Fund MockUSDC contract

The app will now:
- ✅ Check if contracts exist (shows "Contract Not Deployed" if not)
- ✅ Use real contract price from SUITCASE_PRICE
- ✅ Call actual buySuitcase() function
- ✅ Wait for transaction receipt and decode events
- ✅ Show real on-chain prizes in the modal

# How to set up the permissions after deploying contracts

## Step 1: Transfer NFT Ownership to CrazySuitcase
After deploying all contracts, you need to transfer ownership of the NFT contracts to the CrazySuitcase contract so it can mint NFTs for winners.

### For TicketNFT:
1. In Remix, go to the Deploy & Run Transactions tab
2. Find your deployed TicketNFT contract
3. Look for the transferOwnership function
4. Enter the CrazySuitcase contract address as the parameter
5. Click transact and confirm in MetaMask

### For BananaNFT:
1. Find your deployed BananaNFT contract
2. Use the transferOwnership function
3. Enter the CrazySuitcase contract address as the parameter
4. Click transact and confirm in MetaMask

###Step 2: Fund MockUSDC Contract
The CrazySuitcase contract needs USDC tokens to distribute as prizes. You need to mint USDC tokens to the CrazySuitcase contract.
1. Find your deployed MockUSDC contract
2. Look for the mint function (or similar function to create tokens)
3. Enter parameters:
    - To: CrazySuitcase contract address
    - Amount: 1000000000000 (this equals 1,000,000 USDC with 6 decimals)
4. Click transact and confirm in MetaMask

# Verify Setup
You can verify everything is set up correctly by calling these view functions:

## Check CrazySuitcase USDC Balance:
1. Find your CrazySuitcase contract
2. Call getUSDCBalance() function
3. Should return a large number (the USDC you just minted)
## Check NFT Ownership:
1. For TicketNFT: Call owner() - should return CrazySuitcase address
3. For BananaNFT: Call owner() - should return CrazySuitcase address


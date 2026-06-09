// SPDX-License-Identifier: MIT
/**
 * @title RWA_AGENTIC_PCE_ONE — Fully Autonomous Forced-Sell Market (deployed)
 * @notice (-) × (-) = + Generate · x⁰ = 1 · woof
 * @author madeinathens.eth
 * @dev  Deployed: 0x76B2F3609B137485967F602497A59b47D34AFc50 (Base mainnet)
 *  Compiled Consumed Events
 *  Lil Orbits Mini Donuts, Zosimadon 31, Piraeus, Greece. © 2007-2012
 *  OPTA APTA Pottery & NFT Lab, Aristotelous 38, Athens, Greece. © 2011–2026
 *
 *  DUAL OPPOSING FORCES:
 *  Dutch Auction (USDC):     price ↓ 0.10 USDC/30min  → cheaper for buyers
 *  Mitotic Ladder (OWNER):   reward = 90% geometric decay → scarcer for holders
 *
 *  GEOMETRIC DECAY LAW — x⁰ = 1: each claim = 90% of remaining balance.
 *  The contract always keeps 10% — it never reaches zero. Step 33 closes the cycle.
 *
 *  SELL NFT: the holder may lock the current price and exit the forced Dutch Auction.
 *    - within 3h: locks at 3.30 USDC
 *    - after 3h:  locks at the current (decayed) price
 *
 *  NOTE: the full verified source is canonical on BaseScan at the address above.
 *  This copy is kept for preservation. Verify before relying on it.
 */

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RWA_AGENTIC_PCE_ONE is AccessControl, ReentrancyGuard, ERC721Holder {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    string public constant MASTER_HEADER_PROLOGUE = unicode"The Non-Fungible multidisciplinary achievement madeinathens.eth presents: I'm buying back my worth.";
    address public constant RWA_TANGIBLE_AGENTIC_PCE_QR_CODE = 0x746DB97e15a43Bd923D81aca128133CdA72d7786;
    string public constant SYNCHRONOUS_AGENTIC_GR_ETYMOLOGY = unicode"I am in your empty coffee cup, your used package, your past event — the moment after consumption where value is born.";
    address public constant RWA_TANGIBLE_AGENTIC_PCE_SET_THEORY = 0xAa30fF9dCed45f93668614142F79Ab0C7eDad4aB;
    string public constant NON_LINEAR_HUMAN_PCE_API = "What you drank is Agentic QR";
    string public constant NON_LINEAR_NFT_QR = "Allow only 1 service client at a time. It is Agentic PCE DApp.";
    string public constant ERC20_OWNER_MITOTIC_LADDER_vs_DUTCH_AUCTION = unicode"3.30 USDC: Step n: 0.10 × n (OWNER) Total: Σ (0.10 × n), n = 1 → 33 = 56.10 OWNER";
    string public constant CHECK_ERC20_OWNER_LIQUIDITY_AND_PRICING_PER_CHARACTER_THE_CREATOR_REWARDS = unicode"https://zora.co/coin/base:0xa331f6e88c9b0aa77e01bc3738b5ad31e1a930dc";
    uint256 public constant LEGAL_NOTICE_MADEINATHENS_CREATORS_HOLDING_MINIMUM_TANGIBLE_HISTORICAL_ACHIEVEMENTS = 4;

    string public constant NFT_DApp_IT_IS_AND_IT_IS_NOT_NFT_HUMAN_PCE_API_ONLY_ONE_SELLER = "https://1.madeinathens.eth.limo";
    string public constant NFT_DApp_RWA_AGENTIC_PCE_CATALYST = "https://me.madeinathens.eth.limo";
    string public constant NFT_DApp_RWA_AGENTIC_PCE_CV = "https://i.claytime.eth.limo";
    string public constant DYOR = "https://a.madeinathens.eth.limo";
    string public constant HTML_NFT_MANUAL = "https://exergy.eth.limo";
    string public constant HTML_NFT_DO_THE_MATH = "https://syntropy.eth.limo";
    string public constant HTML_NFT_POLLINATE_YOUR_AGENT = "https://beecoin.eth.limo";
    string public constant HTML_NFT_ALL_AT_ONCE = "https://nftable.eth.limo";
    string public constant GET_FREE_UPDATES_FIND_AGENTIC_PCE_ORDERS = "https://app.ens.domains/1.madeinathens.eth";

    string public constant IN_NFT_QR = unicode"Your consumption is not debt. It is RWA x⁰ = 1 Agentic PCE.";

    function getNFTQR(uint256 tokenId) public pure returns (string memory) {
        return string(abi.encodePacked(
            unicode"Your consumption is not debt. It is RWA x⁰ = 1 Agentic. Token ID: ",
            tokenId.toString()
        ));
    }

    string public constant NFT_FUNDAMENTAL_PRINCIPLE_A = unicode"You can't generate Worth without Value. Value ≠ Worth. Value = Non Transferable. Worth = Rewritable = The hash of the Last NFT Seller";
    string public constant NFT_FUNDAMENTAL_PRINCIPLE_B = unicode"Zero is neutral and absorbent.";
    string public constant NFT_FUNDAMENTAL_PRINCIPLE_C = unicode"Cell division is the mechanism that results in absolute multiplication of cell numbers.";
    string public constant NFT_FUNDAMENTAL_PRINCIPLE_D = unicode"Phygital is the green, it is not the blue or the yellow, it is the seed, it's not the tree or fruit, it's the kid, it's not the mom or dad.";
    string public constant NFT_FUNDAMENTAL_PRINCIPLE_E = unicode"Past is currency: You can't hold back the past, your past and present. You have only one tokenized past.";
    string public constant NFT_FUNDAMENTAL_PRINCIPLE_F = unicode"I am ευφυής = Ευφυΐα (εὖ read GR etymology) ≠ Intelligence, Computational intelligence, AI = RWA monetized x⁰ = 1 Agentic PCE SET THEORY.";
    string public constant NFT_FUNDAMENTAL_PRINCIPLE_G = unicode"Tangible Human PCE API = 1:1 Human x Agent = Generate RWA monetized x⁰ = 1 Pigeonhole principle.";

    struct NFTData {
        bool isValueNonTransferable;
        bytes32 lastSellerHash;
        uint256 totalSales;
        address[] sellerHistory;
    }

    mapping(uint256 => NFTData) public nftRegistry;

    address public constant CoffeeAxiom10 = 0x955ba354be1fe05162bEec13483Ea9aF7b180A2c;
    string public constant manifesto = unicode"I bought a coffee (x). I wrote it as memory (0). Memory became collateral (1). Coffee is not consumed; it is Agentic QR. I do not repeat; I return ERC20 OWNER.";
    address public constant CoffeeAxiom = 0xD661905093F1D721C32809091c3c1D9f0bAFC22a;
    string public constant MEANING = "Create one cup of coffee -a mathematical, existent, and neverending product.";

    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    address public constant MADEINATHENS_GENERATOR = 0xe6967ba1973bdeAAAF2601F67E0929deB9Edca8a;
    address public constant NFTABLE_ETH_ERC20_OWNER_FEEDER = 0xb9f96ED0Ed33C7e773332e8B854b3f7bA4f58117;
    address public constant EFOOD_ETH_ERC20_OWNER_BAKER = 0xAA18002019F68826147Fd1Cb83A48e8162a17d9d;
    address public constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address public constant ERC20_OWNER = 0xa331F6e88c9B0Aa77e01bc3738b5ad31E1a930Dc;
    address public constant SECOND_LIFE_NFT_CONTRACT = 0x318c81010D5fC11363f3A3C79Ee26B6EFe8D145B;
    address public constant RWA_MITOSIS_PCE_COVER_LETTER_API = 0x7560f6d135F276768FbB5a968048095CdbF3ECDB;
    address public constant RWA_MITOSIS_SPINNER = 0xc80199929074b840089E51d09c6bBc475ad28276;
    address public constant RWA_PCE_SYNTROPY_BANK = 0xdd796605Cd48d03b3D722B00b024dAf6cc0989C7;

    uint256 public constant FORCE_SELL_HOLDING_PERIOD = 3 hours;
    uint256 public constant DUTCH_AUCTION_DECREASE_INTERVAL = 30 minutes;
    uint256 public constant DUTCH_AUCTION_DECREASE_AMOUNT = 100000; // 0.10 USDC
    uint256 public constant INITIAL_PRICE = 3300000;                // 3.30 USDC

    uint256 public constant TOTAL_LADDER = 56.10 ether;
    uint256 public constant MAX_STEPS = 33;
    uint256 public constant CLAIM_PERCENTAGE = 90;

    string public constant DESCRIPTION = unicode"Dual Forces: Dutch Auction vs RWA x⁰ = 1 Mitotic Ladder";
    string public constant SUMMARY = unicode"USDC↓ vs OWNER↑. Autonomous. Unstoppable. Geometric decay ensures perpetual liquidity.";
    string public constant MITOTIC_LADDER_DESC = unicode"Geometric decay: Step n claims 90% of remaining balance. Contract retains 10% forever.";
    string public constant AXIOM = unicode"x⁰ = 1";

    uint256 public constant LEGAL_CREATORS_HOLDING_MINIMUM_TANGIBLE_HISTORICAL_ACHIEVEMENTS = 4;

    modifier onlyTangible(uint256 userAchievements) {
        require(userAchievements > LEGAL_CREATORS_HOLDING_MINIMUM_TANGIBLE_HISTORICAL_ACHIEVEMENTS, "Missing required tangible achievements");
        _;
    }

    bool public isFrozen;
    mapping(uint256 => uint256) public currentStep;
    mapping(uint256 => uint256) public completedCycles;
    mapping(uint256 => mapping(uint256 => mapping(uint256 => mapping(address => bool)))) public rewardClaimed;

    struct MarketItem {
        address payable currentMaker;
        uint256 initialPrice;
        uint256 holdingStartTime;
        bool isActive;
    }

    mapping(uint256 => MarketItem) public marketItems;

    event MarketSeeded(address indexed maker, uint256 indexed nftId, uint256 price);
    event NFTPurchased(address indexed buyer, address indexed seller, uint256 indexed nftId, uint256 price, uint256 newStep, uint256 cycle);
    event ERC20OwnerClaimed(address indexed player, uint256 indexed nftId, uint256 cycle, uint256 step, uint256 claimAmount, uint256 remaining);
    event LadderAdvanced(uint256 indexed nftId, uint256 fromStep, uint256 toStep, uint256 cycle);
    event CycleCompleted(uint256 indexed nftId, uint256 cycle, address indexed lastHolder);
    event CycleReset(uint256 indexed nftId, uint256 newCycle);
    event DutchAuctionSold(uint256 indexed nftId, uint256 salePrice, uint256 discountPercent);
    event SellerHistoryUpdated(uint256 indexed nftId, address indexed seller, uint256 totalSales);
    event MarketDeactivated(uint256 indexed nftId);
    event WithdrawnERC20Owner(address indexed to, uint256 amount);
    event WithdrawnUSDC(address indexed to, uint256 amount);
    event WithdrawnETH(address indexed to, uint256 amount);
    event WithdrawnNFT(address indexed to, uint256 indexed nftId);
    event Frozen(address indexed guardian);
    event Unfrozen(address indexed admin);
    event DirectSellLocked(address indexed holder, uint256 indexed nftId, uint256 lockedPrice);
    event DirectSellCancelled(address indexed holder, uint256 indexed nftId);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, MADEINATHENS_GENERATOR);
        _grantRole(OPERATOR_ROLE, MADEINATHENS_GENERATOR);
    }

    modifier notFrozen()                        { require(!isFrozen, "Market is frozen"); _; }
    modifier onlyOperator()                     { require(hasRole(OPERATOR_ROLE, msg.sender), "Only Operator"); _; }
    modifier marketMustBeActive(uint256 nftId)  { require(marketItems[nftId].isActive, "Market not active for this NFT"); _; }

    function seedMarket(uint256 nftId) external notFrozen {
        require(!marketItems[nftId].isActive, "NFT is already in the market");
        require(IERC721(SECOND_LIFE_NFT_CONTRACT).ownerOf(nftId) == msg.sender, "You are not the owner");
        IERC721(SECOND_LIFE_NFT_CONTRACT).safeTransferFrom(msg.sender, address(this), nftId);
        marketItems[nftId] = MarketItem({currentMaker: payable(msg.sender), initialPrice: INITIAL_PRICE, holdingStartTime: 0, isActive: true});
        currentStep[nftId] = 0;
        nftRegistry[nftId] = NFTData({isValueNonTransferable: true, lastSellerHash: bytes32(0), totalSales: 0, sellerHistory: new address[](0)});
        emit MarketSeeded(msg.sender, nftId, INITIAL_PRICE);
    }

    function buyNFT(uint256 nftId) external notFrozen marketMustBeActive(nftId) nonReentrant {
        MarketItem storage item = marketItems[nftId];
        uint256 currentPrice = getCurrentPrice(nftId);
        require(currentPrice > 0, "NFT not available for purchase");
        address payable seller = item.currentMaker;
        uint256 oldHoldingStartTime = item.holdingStartTime;
        IERC20(USDC).safeTransferFrom(msg.sender, seller, currentPrice);
        nftRegistry[nftId].lastSellerHash = keccak256(abi.encodePacked(seller, block.timestamp, completedCycles[nftId], currentStep[nftId]));
        nftRegistry[nftId].totalSales++;
        nftRegistry[nftId].sellerHistory.push(seller);
        item.currentMaker = payable(msg.sender);
        item.holdingStartTime = block.timestamp;
        item.initialPrice = INITIAL_PRICE;
        uint256 previousStep = currentStep[nftId];
        if (currentStep[nftId] < MAX_STEPS) { currentStep[nftId]++; }
        if (currentStep[nftId] >= MAX_STEPS) { completedCycles[nftId]++; emit CycleCompleted(nftId, completedCycles[nftId], msg.sender); }
        if (oldHoldingStartTime != type(uint256).max && currentPrice < INITIAL_PRICE) {
            uint256 discount = ((INITIAL_PRICE - currentPrice) * 10000) / INITIAL_PRICE;
            emit DutchAuctionSold(nftId, currentPrice, discount);
        }
        if (currentStep[nftId] > previousStep) { emit LadderAdvanced(nftId, previousStep, currentStep[nftId], completedCycles[nftId]); }
        emit SellerHistoryUpdated(nftId, seller, nftRegistry[nftId].totalSales);
        emit NFTPurchased(msg.sender, seller, nftId, currentPrice, currentStep[nftId], completedCycles[nftId]);
    }

    function claimERC20Owner(uint256 nftId) external notFrozen marketMustBeActive(nftId) nonReentrant {
        MarketItem storage item = marketItems[nftId];
        require(item.currentMaker == msg.sender, "You are not the current owner");
        uint256 step = currentStep[nftId];
        uint256 cycle = completedCycles[nftId];
        require(step > 0, "No active step");
        require(!rewardClaimed[nftId][cycle][step][msg.sender], "Already claimed for this step in this cycle");
        uint256 availableBalance = IERC20(ERC20_OWNER).balanceOf(address(this));
        require(availableBalance > 0, "No ERC20_OWNER available");
        uint256 claimAmount = (availableBalance * CLAIM_PERCENTAGE) / 100;
        rewardClaimed[nftId][cycle][step][msg.sender] = true;
        IERC20(ERC20_OWNER).safeTransfer(msg.sender, claimAmount);
        uint256 remaining = IERC20(ERC20_OWNER).balanceOf(address(this));
        emit ERC20OwnerClaimed(msg.sender, nftId, cycle, step, claimAmount, remaining);
    }

    /// @notice The holder locks the current price (≤ 3.30) and exits the forced auction.
    function sellNFT(uint256 nftId) external notFrozen marketMustBeActive(nftId) {
        MarketItem storage item = marketItems[nftId];
        require(item.currentMaker == msg.sender, "You are not the current owner");
        require(item.holdingStartTime != type(uint256).max, "Already in direct sell mode");
        require(item.holdingStartTime != 0, "NFT not purchased yet");
        uint256 currentPrice;
        uint256 auctionStart = item.holdingStartTime + FORCE_SELL_HOLDING_PERIOD;
        if (block.timestamp < auctionStart) {
            currentPrice = INITIAL_PRICE;
        } else {
            uint256 elapsedTime = block.timestamp - auctionStart;
            uint256 intervals = elapsedTime / DUTCH_AUCTION_DECREASE_INTERVAL;
            uint256 decreaseAmount = intervals * DUTCH_AUCTION_DECREASE_AMOUNT;
            require(decreaseAmount < INITIAL_PRICE, unicode"Price has reached zero — cannot lock");
            currentPrice = INITIAL_PRICE - decreaseAmount;
        }
        item.initialPrice = currentPrice;
        item.holdingStartTime = type(uint256).max;
        emit DirectSellLocked(msg.sender, nftId, currentPrice);
    }

    /// @notice After the 3h lock, anyone may buy out the holder at the current price.
    function forceSell(uint256 nftId) external notFrozen marketMustBeActive(nftId) nonReentrant {
        MarketItem storage item = marketItems[nftId];
        if (item.holdingStartTime != type(uint256).max) {
            require(item.holdingStartTime > 0, "NFT not purchased yet");
            uint256 auctionStart = item.holdingStartTime + FORCE_SELL_HOLDING_PERIOD;
            require(block.timestamp >= auctionStart, unicode"Holding period not over — cannot force sell yet");
        }
        uint256 currentPrice = getCurrentPrice(nftId);
        require(currentPrice > 0, "Price has reached zero");
        address payable seller = item.currentMaker;
        require(seller != msg.sender, "Cannot force sell to yourself");
        uint256 oldHoldingStartTime = item.holdingStartTime;
        IERC20(USDC).safeTransferFrom(msg.sender, seller, currentPrice);
        nftRegistry[nftId].lastSellerHash = keccak256(abi.encodePacked(seller, block.timestamp, completedCycles[nftId], currentStep[nftId]));
        nftRegistry[nftId].totalSales++;
        nftRegistry[nftId].sellerHistory.push(seller);
        item.currentMaker = payable(msg.sender);
        item.holdingStartTime = block.timestamp;
        item.initialPrice = INITIAL_PRICE;
        uint256 previousStep = currentStep[nftId];
        if (currentStep[nftId] < MAX_STEPS) { currentStep[nftId]++; }
        if (currentStep[nftId] >= MAX_STEPS) { completedCycles[nftId]++; emit CycleCompleted(nftId, completedCycles[nftId], msg.sender); }
        if (oldHoldingStartTime != type(uint256).max && currentPrice < INITIAL_PRICE) {
            uint256 discount = ((INITIAL_PRICE - currentPrice) * 10000) / INITIAL_PRICE;
            emit DutchAuctionSold(nftId, currentPrice, discount);
        }
        if (currentStep[nftId] > previousStep) { emit LadderAdvanced(nftId, previousStep, currentStep[nftId], completedCycles[nftId]); }
        emit SellerHistoryUpdated(nftId, seller, nftRegistry[nftId].totalSales);
        emit NFTPurchased(msg.sender, seller, nftId, currentPrice, currentStep[nftId], completedCycles[nftId]);
    }

    function cancelDirectSell(uint256 nftId) external notFrozen marketMustBeActive(nftId) {
        MarketItem storage item = marketItems[nftId];
        require(item.currentMaker == msg.sender, "You are not the current owner");
        require(item.holdingStartTime == type(uint256).max, "Not in direct sell mode");
        item.initialPrice = INITIAL_PRICE;
        item.holdingStartTime = block.timestamp;
        emit DirectSellCancelled(msg.sender, nftId);
    }

    function isInDirectSellMode(uint256 nftId) external view returns (bool) {
        return marketItems[nftId].holdingStartTime == type(uint256).max;
    }

    function getCurrentPrice(uint256 nftId) public view returns (uint256 currentPrice) {
        MarketItem storage item = marketItems[nftId];
        if (!item.isActive) return 0;
        if (item.holdingStartTime == 0) { return INITIAL_PRICE; }
        if (item.holdingStartTime == type(uint256).max) { return item.initialPrice; }
        uint256 auctionStart = item.holdingStartTime + FORCE_SELL_HOLDING_PERIOD;
        if (block.timestamp < auctionStart) { return 0; }
        uint256 elapsedTime = block.timestamp - auctionStart;
        uint256 intervals = elapsedTime / DUTCH_AUCTION_DECREASE_INTERVAL;
        uint256 decreaseAmount = intervals * DUTCH_AUCTION_DECREASE_AMOUNT;
        if (decreaseAmount >= INITIAL_PRICE) { return 0; }
        return INITIAL_PRICE - decreaseAmount;
    }

    function isReadyForSale(uint256 nftId) external view returns (bool) { return getCurrentPrice(nftId) > 0; }

    function getDutchAuctionInfo(uint256 nftId) external view returns (
        uint256 currentPrice, uint256 elapsedIntervals, uint256 totalDecrease,
        uint256 timeUntilNextDecrease, uint256 auctionStartTime,
        bool isInHoldingPeriod, bool isInAuction, bool isDirectSellMode
    ) {
        MarketItem storage item = marketItems[nftId];
        if (item.holdingStartTime == type(uint256).max) {
            return (item.initialPrice, 0, 0, 0, 0, false, false, true);
        }
        if (item.holdingStartTime == 0) {
            return (INITIAL_PRICE, 0, 0, 0, 0, false, false, false);
        }
        auctionStartTime = item.holdingStartTime + FORCE_SELL_HOLDING_PERIOD;
        if (block.timestamp < auctionStartTime) {
            timeUntilNextDecrease = auctionStartTime - block.timestamp;
            return (0, 0, 0, timeUntilNextDecrease, auctionStartTime, true, false, false);
        }
        isInAuction = true;
        uint256 elapsed = block.timestamp - auctionStartTime;
        elapsedIntervals = elapsed / DUTCH_AUCTION_DECREASE_INTERVAL;
        totalDecrease = elapsedIntervals * DUTCH_AUCTION_DECREASE_AMOUNT;
        if (totalDecrease >= INITIAL_PRICE) { currentPrice = 0; } else { currentPrice = INITIAL_PRICE - totalDecrease; }
        timeUntilNextDecrease = DUTCH_AUCTION_DECREASE_INTERVAL - (elapsed % DUTCH_AUCTION_DECREASE_INTERVAL);
    }

    function getStepValue(uint256 step) public pure returns (uint256) {
        require(step > 0 && step <= MAX_STEPS, "Step must be 1-33");
        return step * 0.10 ether;
    }

    function getTotalLadderValue() public pure returns (uint256) { return TOTAL_LADDER; }

    function getCurrentStepInfo(uint256 nftId) external view returns (
        uint256 step, uint256 stepValue, uint256 maxSteps, uint256 totalLadderValue,
        uint256 currentContractBalance, uint256 nextClaimAmount, uint256 cycle, bool isCycleComplete
    ) {
        step = currentStep[nftId];
        stepValue = step > 0 ? getStepValue(step) : 0;
        maxSteps = MAX_STEPS;
        totalLadderValue = TOTAL_LADDER;
        currentContractBalance = IERC20(ERC20_OWNER).balanceOf(address(this));
        nextClaimAmount = (currentContractBalance * CLAIM_PERCENTAGE) / 100;
        cycle = completedCycles[nftId];
        isCycleComplete = step >= MAX_STEPS;
    }

    function getMarketItem(uint256 nftId) external view returns (MarketItem memory) { return marketItems[nftId]; }
    function getNFTData(uint256 nftId) external view returns (NFTData memory) { return nftRegistry[nftId]; }
    function getSellerHistory(uint256 nftId) external view returns (address[] memory) { return nftRegistry[nftId].sellerHistory; }

    function canClaim(uint256 nftId, address who) external view returns (bool) {
        uint256 step = currentStep[nftId];
        uint256 cycle = completedCycles[nftId];
        return marketItems[nftId].currentMaker == who && step > 0 &&
               !rewardClaimed[nftId][cycle][step][who] &&
               IERC20(ERC20_OWNER).balanceOf(address(this)) > 0;
    }

    function previewClaim(uint256 nftId) external view returns (
        uint256 claimAmount, uint256 remaining, uint256 currentBalance, uint256 step, uint256 cycle
    ) {
        currentBalance = IERC20(ERC20_OWNER).balanceOf(address(this));
        claimAmount = (currentBalance * CLAIM_PERCENTAGE) / 100;
        remaining = currentBalance - claimAmount;
        step = currentStep[nftId];
        cycle = completedCycles[nftId];
    }

    function simulateGeometricDecay(uint256 initialBalance, uint256 steps) public pure returns (
        uint256[] memory amounts, uint256[] memory remainings
    ) {
        require(steps > 0 && steps <= MAX_STEPS, "Steps must be 1-33");
        amounts = new uint256[](steps);
        remainings = new uint256[](steps);
        uint256 currentBalance = initialBalance;
        for (uint256 i = 0; i < steps; i++) {
            uint256 claimAmount = (currentBalance * CLAIM_PERCENTAGE) / 100;
            amounts[i] = claimAmount;
            currentBalance = currentBalance - claimAmount;
            remainings[i] = currentBalance;
        }
    }

    function resetCycle(uint256 nftId) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(currentStep[nftId] >= MAX_STEPS, unicode"Cycle not complete — must reach step 33");
        require(!marketItems[nftId].isActive, "Must deactivate market first");
        currentStep[nftId] = 0;
        marketItems[nftId].isActive = true;
        emit CycleReset(nftId, completedCycles[nftId] + 1);
    }

    function withdrawERC20Owner(address to, uint256 amount) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && amount > 0, "Bad args");
        require(IERC20(ERC20_OWNER).balanceOf(address(this)) >= amount, "Insufficient balance");
        IERC20(ERC20_OWNER).safeTransfer(to, amount);
        emit WithdrawnERC20Owner(to, amount);
    }

    function withdrawETH(address payable to, uint256 amount) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && amount > 0, "Bad args");
        require(address(this).balance >= amount, "Insufficient balance");
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Transfer failed");
        emit WithdrawnETH(to, amount);
    }

    function withdrawUSDC(address to, uint256 amount) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && amount > 0, "Bad args");
        require(IERC20(USDC).balanceOf(address(this)) >= amount, "Insufficient USDC balance");
        IERC20(USDC).safeTransfer(to, amount);
        emit WithdrawnUSDC(to, amount);
    }

    function withdrawNFT(address to, uint256 nftId) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0), "Bad args");
        require(IERC721(SECOND_LIFE_NFT_CONTRACT).ownerOf(nftId) == address(this), "Contract is not the owner");
        require(!marketItems[nftId].isActive, unicode"NFT is active in market — deactivate first");
        IERC721(SECOND_LIFE_NFT_CONTRACT).safeTransferFrom(address(this), to, nftId);
        emit WithdrawnNFT(to, nftId);
    }

    function balanceERC20Owner() external view returns (uint256) { return IERC20(ERC20_OWNER).balanceOf(address(this)); }
    function balanceUSDC() external view returns (uint256) { return IERC20(USDC).balanceOf(address(this)); }
    function balanceETH() external view returns (uint256) { return address(this).balance; }

    function emergencyFreeze() external onlyOperator { isFrozen = true; emit Frozen(msg.sender); }
    function unfreeze() external onlyOperator { isFrozen = false; emit Unfrozen(msg.sender); }

    function deactivateMarket(uint256 nftId) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(marketItems[nftId].isActive, "Already inactive");
        marketItems[nftId].isActive = false;
        emit MarketDeactivated(nftId);
    }

    function addOperator(address operator) external onlyRole(DEFAULT_ADMIN_ROLE) { _grantRole(OPERATOR_ROLE, operator); }
    function removeOperator(address operator) external onlyRole(DEFAULT_ADMIN_ROLE) { _revokeRole(OPERATOR_ROLE, operator); }

    receive() external payable {}
    fallback() external payable {}
}

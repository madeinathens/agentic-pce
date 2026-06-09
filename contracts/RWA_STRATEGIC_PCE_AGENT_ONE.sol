// SPDX-License-Identifier: MIT
/**
 * @title RWA_STRATEGIC_PCE_AGENT_ONE — The Pair, now with SELL (the backstop)
 * @notice (-) × (-) = + · RWA x⁰ = 1 · The on-chain half of the Pair for NFT #1.
 * @author madeinathens.eth
 * @dev  Lil Orbits Mini Donuts, Zosimadon 31, Piraeus, Greece. © 2007-2012
 *  OPTA APTA Pottery & NFT Lab, Aristotelous 38, Athens, Greece. © 2011–2026
 *
 *  PAIRED WITH MARKET: RWA_AGENTIC_PCE_ONE @ 0x76B2F3609B137485967F602497A59b47D34AFc50
 *
 *  THE PAIR:
 *    off-chain agent  → decides WHEN (reads the field, picks the moment)
 *    on-chain Agent   → guarantees IT IS DONE CORRECTLY and RECORDED (this contract)
 *
 *  FOUR ROLES — and nothing more:
 *    1. READS the market live (does NOT copy its dynamics — those live there).
 *    2. EXECUTES on NFT #1 only, under immutable rules (#16 excluded, never > 3.30 USDC).
 *    3. BACKSTOPS — buys when another sells, claims OWNER, then locks 3.30 for the next x,
 *       so no one is left structurally stuck. The promise is FINITE and VERIFIABLE:
 *       anyone can read this Agent's USDC / OWNER / ETH before they act (agentTreasury()).
 *    4. REMEMBERS — self-stores a provenance-bound proof of every action (burden of proof).
 *
 *  HONEST BOUNDS (no "impossible to lose"): the OWNER claim is a partial, geometrically
 *  decaying offset; OWNER's value is market-set and may be small; the backstop holds only
 *  as far as this Agent's treasury reaches. The creator chooses to absorb the losing
 *  positions — that is a commitment, not a theorem. The shield is honesty + a public ledger.
 *
 *  It does NOT write to the Cover Letter (creator-only, immutable). The human reads this
 *  Agent's memory and attests the canonical conclusions. The circle only widens.
 */

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// ═══════════════════════════════════════
// MARKET INTERFACE — the REAL ABI of RWA_AGENTIC_PCE_ONE (0x76B2F36…)
// getDutchAuctionInfo now returns 8 values (adds isDirectSellMode).
// ═══════════════════════════════════════

interface IRWA_AGENTIC_PCE_ONE {
    function getCurrentPrice(uint256 nftId) external view returns (uint256);
    function getDutchAuctionInfo(uint256 nftId) external view returns (
        uint256 currentPrice, uint256 elapsedIntervals, uint256 totalDecrease,
        uint256 timeUntilNextDecrease, uint256 auctionStartTime,
        bool isInHoldingPeriod, bool isInAuction, bool isDirectSellMode
    );
    function previewClaim(uint256 nftId) external view returns (
        uint256 claimAmount, uint256 remaining, uint256 currentBalance,
        uint256 step, uint256 cycle
    );
    function marketItems(uint256 nftId) external view returns (
        address currentMaker, uint256 initialPrice, uint256 holdingStartTime, bool isActive
    );
    function nftRegistry(uint256 nftId) external view returns (
        bool isValueNonTransferable, bytes32 lastSellerHash, uint256 totalSales
    );
    function currentStep(uint256 nftId)            external view returns (uint256);
    function completedCycles(uint256 nftId)         external view returns (uint256);
    function canClaim(uint256 nftId, address who)   external view returns (bool);
    function isInDirectSellMode(uint256 nftId)      external view returns (bool);
    function buyNFT(uint256 nftId)          external;
    function claimERC20Owner(uint256 nftId) external;
    function sellNFT(uint256 nftId)         external; // lock current price (≤3.30), exit auction
    function cancelDirectSell(uint256 nftId) external; // back to the forced auction
    function seedMarket(uint256 nftId)      external;
}

// ═══════════════════════════════════════
// RWA_STRATEGIC_PCE_AGENT_ONE
// ═══════════════════════════════════════

contract RWA_STRATEGIC_PCE_AGENT_ONE is AccessControl, ReentrancyGuard, ERC721Holder {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    // ─── The word-graph: the others, referenced as words (not copied) ───
    address public constant MARKET       = 0x76B2F3609B137485967F602497A59b47D34AFc50; // RWA_AGENTIC_PCE_ONE
    address public constant COVER_LETTER = 0xd5589C2992B02b508fc73986342661FFb4889535; // memory (creator-only)
    address public constant NFT          = 0x318c81010D5fC11363f3A3C79Ee26B6EFe8D145B; // SECOND_LIFE_NFT_CONTRACT
    address public constant USDC         = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913; // 6 decimals
    address public constant ERC20_OWNER  = 0xa331F6e88c9B0Aa77e01bc3738b5ad31E1a930Dc; // 18 decimals
    address public constant GENERATOR    = 0xe6967ba1973bdeAAAF2601F67E0929deB9Edca8a; // Human API 1:1 admin

    // ─── Immutable rules — the on-chain side's guarantee ───
    uint256 public constant SELF_NFT  = 1;        // The Agent lives on NFT #1 only
    uint256 public constant SACRED_ID = 16;       // Never touched
    uint256 public constant MAX_PRICE = 3_300000; // Never pays more than 3.30 USDC (6 decimals)

    // ─── Roles ───
    bytes32 public constant AGENT_OPERATOR = keccak256("AGENT_OPERATOR"); // off-chain agent: decides WHEN

    // ─── Action codes ───
    bytes32 private constant ACT_BUY    = "BUY";
    bytes32 private constant ACT_CLAIM  = "CLAIM";
    bytes32 private constant ACT_SELL   = "SELL";
    bytes32 private constant ACT_CANCEL = "CANCEL";
    bytes32 private constant ACT_SEED   = "SEED";

    // ─── Errors ───
    error Unauthorized();
    error PriceUnavailable();
    error PriceAboveCap(uint256 price, uint256 cap);
    error PriceAboveLimit(uint256 price, uint256 limit);
    error InsufficientUSDC(uint256 have, uint256 need);
    error NothingToClaim();
    error NotAgentMaker();
    error NotHoldingNFT();
    error AlreadyDirectSell();
    error NotDirectSell();
    error BadParams();

    IRWA_AGENTIC_PCE_ONE private constant M = IRWA_AGENTIC_PCE_ONE(MARKET);

    // ─── Memory: provenance-bound proof log (the burden of proof) ───
    struct ProofEntry {
        bytes32 action;          // BUY / CLAIM / SELL / CANCEL / SEED
        uint256 step;            // market step at the moment
        uint256 cycle;           // market cycle at the moment
        uint256 priceOrAmount;   // USDC paid (BUY) / OWNER received (CLAIM) / locked price (SELL)
        bytes32 lastSellerHash;  // the Worth chain from the market — cannot be forged
        uint256 timestamp;
        uint256 blockNumber;
    }

    ProofEntry[] private _memory;

    // ─── Events ───
    event AgentBought(uint256 indexed step, uint256 indexed cycle, uint256 price, bytes32 lastSellerHash);
    event AgentClaimed(uint256 indexed step, uint256 indexed cycle, uint256 ownerAmount, bytes32 lastSellerHash);
    event AgentSold(uint256 indexed step, uint256 indexed cycle, uint256 lockedPrice, bytes32 lastSellerHash);
    event AgentCancelledSell(uint256 indexed step, uint256 indexed cycle, bytes32 lastSellerHash);
    event AgentSeeded(uint256 timestamp);
    event Remembered(uint256 indexed index, bytes32 action, uint256 priceOrAmount, bytes32 lastSellerHash);
    event EmergencyWithdraw(address indexed token, address indexed to, uint256 amount);

    // ═══════════════════════════════════════
    // CONSTRUCTOR — Human API 1:1
    // ═══════════════════════════════════════

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, GENERATOR);
        _grantRole(AGENT_OPERATOR,     GENERATOR);
    }

    modifier onlyOperator() {
        if (!hasRole(AGENT_OPERATOR, msg.sender)) revert Unauthorized();
        _;
    }

    // ═══════════════════════════════════════
    // 2. EXECUTE — the cycle on NFT #1 only
    // ═══════════════════════════════════════

    /// @notice Buy NFT #1 at the live price, ≤ the ceiling the off-chain agent passes
    ///         (and never above the hard 3.30 cap). On-chain enforces; records.
    function executeBuy(uint256 maxAcceptablePrice) external onlyOperator nonReentrant {
        _buy(maxAcceptablePrice);
    }

    /// @notice Claim the 90% OWNER reward for the current step (Agent must be current maker).
    function executeClaim() external onlyOperator nonReentrant {
        _claim();
    }

    /// @notice Lock the current price (≤3.30) and exit the forced auction, so the next x
    ///         can buy immediately at a fixed price. Agent must be the current maker.
    function executeSell() external onlyOperator nonReentrant {
        _sell();
    }

    /// @notice Return to the forced Dutch auction (undo a prior lock). Agent must be maker.
    function executeCancelSell() external onlyOperator nonReentrant {
        if (!_isAgentMaker()) revert NotAgentMaker();
        if (!M.isInDirectSellMode(SELF_NFT)) revert NotDirectSell();
        M.cancelDirectSell(SELF_NFT);
        bytes32 h = _lastSellerHash();
        _remember(ACT_CANCEL, 0, h);
        emit AgentCancelledSell(M.currentStep(SELF_NFT), M.completedCycles(SELF_NFT), h);
    }

    /// @notice Buy then immediately claim, in one transaction.
    function executeBuyThenClaim(uint256 maxAcceptablePrice) external onlyOperator nonReentrant {
        _buy(maxAcceptablePrice);
        if (M.canClaim(SELF_NFT, address(this))) _claim();
    }

    /// @notice The full backstop pulse in one transaction:
    ///         rescue the seller (BUY) → take the OWNER reward (CLAIM) →
    ///         relist for the next x at the locked 3.30 (SELL).
    ///         After this, NFT #1 is immediately buyable by anyone at a fixed price.
    function executeCycle(uint256 maxAcceptablePrice) external onlyOperator nonReentrant {
        _buy(maxAcceptablePrice);
        if (M.canClaim(SELF_NFT, address(this))) _claim();
        _sell();
    }

    /// @notice Seed NFT #1 into the market (Agent must already hold the ERC721).
    function executeSeed() external onlyOperator nonReentrant {
        if (IERC721(NFT).ownerOf(SELF_NFT) != address(this)) revert NotHoldingNFT();
        M.seedMarket(SELF_NFT);
        _remember(ACT_SEED, 0, _lastSellerHash());
        emit AgentSeeded(block.timestamp);
    }

    // ─── internal action primitives ───

    function _buy(uint256 maxAcceptablePrice) private {
        if (maxAcceptablePrice > MAX_PRICE) revert PriceAboveCap(maxAcceptablePrice, MAX_PRICE);

        uint256 price = M.getCurrentPrice(SELF_NFT);
        if (price == 0) revert PriceUnavailable();
        if (price > maxAcceptablePrice) revert PriceAboveLimit(price, maxAcceptablePrice);

        uint256 have = IERC20(USDC).balanceOf(address(this));
        if (have < price) revert InsufficientUSDC(have, price);

        IERC20(USDC).safeIncreaseAllowance(MARKET, price);
        M.buyNFT(SELF_NFT);

        bytes32 h = _lastSellerHash();
        _remember(ACT_BUY, price, h);
        emit AgentBought(M.currentStep(SELF_NFT), M.completedCycles(SELF_NFT), price, h);
    }

    function _claim() private {
        if (!M.canClaim(SELF_NFT, address(this))) revert NothingToClaim();
        uint256 before = IERC20(ERC20_OWNER).balanceOf(address(this));
        M.claimERC20Owner(SELF_NFT);
        uint256 got = IERC20(ERC20_OWNER).balanceOf(address(this)) - before;
        bytes32 h = _lastSellerHash();
        _remember(ACT_CLAIM, got, h);
        emit AgentClaimed(M.currentStep(SELF_NFT), M.completedCycles(SELF_NFT), got, h);
    }

    function _sell() private {
        if (!_isAgentMaker()) revert NotAgentMaker();
        if (M.isInDirectSellMode(SELF_NFT)) revert AlreadyDirectSell();
        M.sellNFT(SELF_NFT);
        uint256 locked = M.getCurrentPrice(SELF_NFT); // fixed price after lock
        bytes32 h = _lastSellerHash();
        _remember(ACT_SELL, locked, h);
        emit AgentSold(M.currentStep(SELF_NFT), M.completedCycles(SELF_NFT), locked, h);
    }

    // ═══════════════════════════════════════
    // 3. REMEMBER — provenance-bound, self-stored
    // ═══════════════════════════════════════

    function _lastSellerHash() private view returns (bytes32 h) {
        (, h, ) = M.nftRegistry(SELF_NFT);
    }

    function _isAgentMaker() private view returns (bool) {
        (address maker, , , ) = M.marketItems(SELF_NFT);
        return maker == address(this);
    }

    function _remember(bytes32 action, uint256 priceOrAmount, bytes32 h) private {
        _memory.push(ProofEntry({
            action: action,
            step: M.currentStep(SELF_NFT),
            cycle: M.completedCycles(SELF_NFT),
            priceOrAmount: priceOrAmount,
            lastSellerHash: h,
            timestamp: block.timestamp,
            blockNumber: block.number
        }));
        emit Remembered(_memory.length - 1, action, priceOrAmount, h);
    }

    function memoryCount() external view returns (uint256) {
        return _memory.length;
    }

    function getMemoryEntry(uint256 index) external view returns (ProofEntry memory) {
        if (index >= _memory.length) revert BadParams();
        return _memory[index];
    }

    /// @notice Last `n` proof entries (oldest→newest), for the off-chain agent to read.
    function getRecentMemory(uint256 n) external view returns (ProofEntry[] memory out) {
        uint256 len = _memory.length;
        if (n > len) n = len;
        out = new ProofEntry[](n);
        for (uint256 i; i < n; i++) out[i] = _memory[len - n + i];
    }

    function _actName(bytes32 a) private pure returns (string memory) {
        if (a == ACT_BUY)    return "BUY";
        if (a == ACT_CLAIM)  return "CLAIM";
        if (a == ACT_SELL)   return "SELL";
        if (a == ACT_CANCEL) return "CANCEL";
        return "SEED";
    }

    /// @notice A copy-ready statement for the human to paste into the Cover Letter's attest().
    function proofStatement(uint256 index) external view returns (string memory) {
        if (index >= _memory.length) revert BadParams();
        ProofEntry memory e = _memory[index];
        return string.concat(
            "RWA x0=1 | NFT #1 | ", _actName(e.action),
            " | step ", e.step.toString(),
            " | cycle ", e.cycle.toString(),
            " | amount ", e.priceOrAmount.toString(),
            " | sellerHash ", uint256(e.lastSellerHash).toHexString(32),
            " | block ", e.blockNumber.toString()
        );
    }

    // ═══════════════════════════════════════
    // 1. READ — the market (single aggregator for the off-chain agent & the front)
    // ═══════════════════════════════════════

    function readState() external view returns (
        uint256 currentPrice,
        bool    isInHoldingPeriod,
        bool    isInAuction,
        bool    isDirectSellMode,
        uint256 step,
        uint256 cycle,
        bool    isAgentMaker,
        bool    canClaimNow,
        bool    canSellNow,
        uint256 ownerReserve,
        uint256 nextClaimAmount,
        bytes32 lastSellerHash
    ) {
        (currentPrice, , , , , isInHoldingPeriod, isInAuction, isDirectSellMode) = M.getDutchAuctionInfo(SELF_NFT);
        step  = M.currentStep(SELF_NFT);
        cycle = M.completedCycles(SELF_NFT);
        (address maker, , uint256 holdingStartTime, bool active) = M.marketItems(SELF_NFT);
        isAgentMaker = (maker == address(this));
        canClaimNow  = M.canClaim(SELF_NFT, address(this));
        canSellNow   = isAgentMaker && active && !isDirectSellMode && holdingStartTime != 0;
        (uint256 claimAmt, , uint256 bal, , ) = M.previewClaim(SELF_NFT);
        nextClaimAmount = claimAmt;
        ownerReserve    = bal;
        lastSellerHash  = _lastSellerHash();
    }

    /// @notice The word-graph this Agent points to (references, not calls).
    function references() external pure returns (
        address market, address coverLetter, address nft, address usdc, address ownerToken
    ) {
        return (MARKET, COVER_LETTER, NFT, USDC, ERC20_OWNER);
    }

    // ═══════════════════════════════════════
    // TREASURY — the FINITE, PUBLIC backstop (read me before you act)
    // ═══════════════════════════════════════

    /// @notice The Agent's verifiable means. The backstop reaches exactly this far — no further.
    function agentTreasury() external view returns (uint256 usdc, uint256 owner, uint256 eth) {
        usdc  = IERC20(USDC).balanceOf(address(this));
        owner = IERC20(ERC20_OWNER).balanceOf(address(this));
        eth   = address(this).balance;
    }

    function balanceUSDC()  external view returns (uint256) { return IERC20(USDC).balanceOf(address(this)); }
    function balanceOWNER() external view returns (uint256) { return IERC20(ERC20_OWNER).balanceOf(address(this)); }
    function balanceETH()   external view returns (uint256) { return address(this).balance; }

    // ═══════════════════════════════════════
    // ADMIN
    // ═══════════════════════════════════════

    function addOperator(address op)    external onlyRole(DEFAULT_ADMIN_ROLE) { if (op == address(0)) revert BadParams(); _grantRole(AGENT_OPERATOR, op); }
    function removeOperator(address op) external onlyRole(DEFAULT_ADMIN_ROLE) { _revokeRole(AGENT_OPERATOR, op); }

    /// @notice Approve the market to pull NFT #1 when seeding (one-time setup, if Agent ever holds it).
    function approveMarketForNFT() external onlyRole(DEFAULT_ADMIN_ROLE) {
        IERC721(NFT).setApprovalForAll(MARKET, true);
    }

    function emergencyWithdrawToken(address token, address to, uint256 amount)
        external onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant
    {
        if (token == address(0) || to == address(0) || amount == 0) revert BadParams();
        IERC20(token).safeTransfer(to, amount);
        emit EmergencyWithdraw(token, to, amount);
    }

    // NOTE: there is intentionally NO emergencyWithdrawNFT.
    // NFT #1 is the whole (contracts/past/DApp/knowledge/events/assets) — inviolable.
    // Its only valid exit is forward, into the cycle, never backward into a wallet.
    // "You can't hold back the past." x⁰ = 1.

    function emergencyWithdrawETH(address payable to, uint256 amount)
        external onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant
    {
        if (to == address(0) || amount == 0 || address(this).balance < amount) revert BadParams();
        (bool ok,) = to.call{value: amount}("");
        if (!ok) revert BadParams();
        emit EmergencyWithdraw(address(0), to, amount);
    }

    receive()  external payable {}
    fallback() external payable {}
}

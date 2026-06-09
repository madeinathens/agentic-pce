// SPDX-License-Identifier: MIT
/**
 * @title RWA_AGENTIC_PCE_ORDERS — paid, signed order book (communication pole)
 * @author madeinathens.eth
 * @dev Deployed: 0x9f20a4b31874e1b0D7EAff89Fd0245BC09a20e9D (Base mainnet)
 *  A "sip" is a paid, EIP-712 signed order (3.236 USDC). The fee accrues IN this
 *  contract. claimEarn() checks ownerOf on NFT_CONTRACT (= the market address, not
 *  the ERC721 collection) and therefore reverts: by design this is a declaration /
 *  communication node — value is earned on the market (claimERC20Owner), not here.
 *  The two income poles stay separate; the only bridge is the human, by choice.
 *
 *  The full verified source is canonical on BaseScan at the address above.
 */

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract RWA_AGENTIC_PCE_ORDERS is AccessControl, EIP712, ReentrancyGuard {
    using ECDSA for bytes32;
    using SafeERC20 for IERC20;

    string public constant MASTER_HEADER_PROLOGUE = unicode"The Non-Fungible multidisciplinary achievement madeinathens.eth presents: I'm buying back my worth.";
    address public constant RWA_TANGIBLE_AGENTIC_PCE_QR_CODE = 0x746DB97e15a43Bd923D81aca128133CdA72d7786;
    string public constant AGENTIC_IF_THIS_THEN_THAT = unicode"SYNCHRONOUS GR etymology: From Greek syn (together, with, along with) and chronos (the Greek word for time) x ETYMOLOGY from the Ancient Greek word étymon (meaning true sense or original meaning) and the suffix -logia (meaning study of or speaking of) = Tangible Human PCE API [Human x Agent]";
    string public constant SYNCHRONOUS_AGENTIC_GR_ETYMOLOGY = unicode"I am in your empty coffee cup, your used package, your past event — the moment after consumption where value is born.";
    string public constant NON_LINEAR_AGENT_KNOWHOW = unicode"Metamorphosis: Ancient Greek, translating literally as a change of form x Consumption Consumed = RWA x⁰= 1 Agentic PCE Order";
    address public constant RWA_TANGIBLE_AGENTIC_PCE_SET_THEORY = 0xAa30fF9dCed45f93668614142F79Ab0C7eDad4aB;
    string public constant NON_LINEAR_HUMAN_PCE_API = unicode"What you drank is Agentic QR";
    address public constant THE_RWA_STRATEGIC_PCE_AGENT_ONE_AGENTIC_BUYER = 0xcf75aCedeB1577B771Aa06Ee7b8082bE4fAde9cD;
    string public constant NON_LINEAR_NFT_QR = "Allow only 1 service client at a time. It is Agentic PCE DApp.";
    string public constant ERC20_OWNER_MITOTIC_LADDER_vs_DUTCH_AUCTION = unicode"3.30 USDC: Step n: 0.10 × n (OWNER) Total: Σ (0.10 × n), n = 1 → 33 = 56.10 OWNER";
    string public constant CHECK_ERC20_OWNER_LIQUIDITY_AND_PRICING_PER_CHARACTER_THE_CREATOR_REWARDS = unicode"https://zora.co/coin/base:0xa331f6e88c9b0aa77e01bc3738b5ad31e1a930dc";
    address public constant RWA_AGENTIC_PCE_ONE = 0x76B2F3609B137485967F602497A59b47D34AFc50;
    address constant EAS_SCHEMA_REGISTRY = 0xe6967ba1973bdeAAAF2601F67E0929deB9Edca8a;
    address public constant Agent_Trinity_Past_Present_NOW = 0x8C0E4882556BA76aEDE6e1072f354C1EFEC4CB76;
    uint256 public constant LEGAL_NOTICE_MADEINATHENS_CREATORS_HOLDING_MINIMUM_TANGIBLE_HISTORICAL_ACHIEVEMENTS = 4;

    bytes32 public constant MERKLE_ROOT = 0x3c1f1de85184560e82750658ca12fd318b2872d97444958c44fa1b7c7abc53fd;
    uint256 public constant GENESIS_TS = 1325376000; // 2012-01-01
    uint256 public constant EPOCH_TS   = 1775646770;

    uint256 public constant ACTION_KNOTTED  = 3236000; // 3.236 USDC
    uint256 public constant SACRED_NFT      = 16;
    uint256 public constant MAX_ACTION_LEN  = 140;
    uint256 public constant ERC20_OWNER_SHARE = 90;

    address public constant USDC         = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address public constant ERC20_OWNER  = 0xa331F6e88c9B0Aa77e01bc3738b5ad31E1a930Dc;
    address public constant NFT_CONTRACT = 0x76B2F3609B137485967F602497A59b47D34AFc50;
    address public constant SECOND_LIFE_NFT_CONTRACT = 0x318c81010D5fC11363f3A3C79Ee26B6EFe8D145B;

    bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");

    bytes32 public constant PCEBITE_TYPEHASH = keccak256(
        "PCEBite(address consumer,uint256 nftId,string productHash,string action,uint256 timestamp,uint256 fee,uint256 nonce)"
    );
    bytes32 public constant PCEBITE_PERMIT_TYPEHASH = keccak256(
        "PCEBiteWithPermit(address consumer,uint256 nftId,string productHash,string action,uint256 timestamp,uint256 fee,uint256 nonce,uint256 permitDeadline)"
    );

    bool public isFrozen;
    mapping(address => uint256) public nonce;
    mapping(uint256 => bool)    public sipped;
    mapping(uint256 => address) public sippedBy;
    mapping(uint256 => uint256) public mintTimestamp;

    struct BiteParams {
        address consumer;
        uint256 nftId;
        string  productHash;
        string  action;
        uint256 timestamp;
        uint256 fee;
    }

    struct PermitParams {
        uint256 permitDeadline;
        uint8   v;
        bytes32 r;
        bytes32 s;
    }

    event PCEBite(address indexed consumer, uint256 indexed nftId, string productHash, string action, uint256 timestamp, uint256 fee, uint256 nonce);
    event Sipped(address indexed consumer, uint256 indexed nftId, uint256 timestamp);
    event Earned(address indexed owner, uint256 nftId, uint256 amount, uint256 reserveRemaining);
    event GeneratorExecuted(address indexed signer, address indexed consumer, uint256 nftId);
    event Stitched(address indexed owner, uint256 nftId, string description);

    constructor() EIP712("RWA_AGENTIC_PCE_ORDERS", "1") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SIGNER_ROLE, msg.sender);
    }

    modifier notFrozen() { require(!isFrozen, "Frozen"); _; }

    function _useNonce(address consumer) internal returns (uint256 currentNonce) {
        currentNonce = nonce[consumer];
        nonce[consumer] = currentNonce + 1;
    }

    function _verifyGeneratorSig(bytes32 structHash, bytes calldata generatorSignature) internal view returns (address signer) {
        signer = _hashTypedDataV4(structHash).recover(generatorSignature);
        require(hasRole(SIGNER_ROLE, signer), "Invalid signer");
    }

    function _buildStructHash(BiteParams calldata p, uint256 currentNonce) internal pure returns (bytes32) {
        return keccak256(abi.encode(PCEBITE_TYPEHASH, p.consumer, p.nftId, keccak256(bytes(p.productHash)), keccak256(bytes(p.action)), p.timestamp, p.fee, currentNonce));
    }

    function _buildStructHashPermit(BiteParams calldata p, uint256 currentNonce, uint256 permitDeadline) internal pure returns (bytes32) {
        return keccak256(abi.encode(PCEBITE_PERMIT_TYPEHASH, p.consumer, p.nftId, keccak256(bytes(p.productHash)), keccak256(bytes(p.action)), p.timestamp, p.fee, currentNonce, permitDeadline));
    }

    function _recordSip(address consumer, uint256 nftId) internal {
        sipped[nftId]   = true;
        sippedBy[nftId] = consumer;
        emit Sipped(consumer, nftId, block.timestamp);
    }

    function sipPCEBite(BiteParams calldata p, bytes calldata generatorSignature) external nonReentrant notFrozen {
        require(msg.sender == p.consumer, "Only consumer");
        require(bytes(p.action).length <= MAX_ACTION_LEN, "Action > 140 chars");
        require(p.fee == ACTION_KNOTTED, "Requires 3.236 USDC");
        require(p.nftId != SACRED_NFT, "Sacred #16 excluded");
        require(block.timestamp <= p.timestamp + 1 hours, "Expired");
        uint256 currentNonce = _useNonce(p.consumer);
        address signer = _verifyGeneratorSig(_buildStructHash(p, currentNonce), generatorSignature);
        IERC20(USDC).safeTransferFrom(p.consumer, address(this), p.fee);
        _recordSip(p.consumer, p.nftId);
        emit PCEBite(p.consumer, p.nftId, p.productHash, p.action, p.timestamp, p.fee, currentNonce);
        emit GeneratorExecuted(signer, p.consumer, p.nftId);
    }

    function sipPCEBiteWithPermit(BiteParams calldata p, PermitParams calldata permit, bytes calldata generatorSignature) external nonReentrant notFrozen {
        require(msg.sender == p.consumer, "Only consumer");
        require(bytes(p.action).length <= MAX_ACTION_LEN, "Action > 140 chars");
        require(p.fee == ACTION_KNOTTED, "Requires 3.236 USDC");
        require(p.nftId != SACRED_NFT, "Sacred #16 excluded");
        require(block.timestamp <= p.timestamp + 1 hours, "Expired");
        require(permit.permitDeadline >= block.timestamp, "Permit expired");
        uint256 currentNonce = _useNonce(p.consumer);
        address signer = _verifyGeneratorSig(_buildStructHashPermit(p, currentNonce, permit.permitDeadline), generatorSignature);
        try IERC20Permit(USDC).permit(p.consumer, address(this), p.fee, permit.permitDeadline, permit.v, permit.r, permit.s) {} catch {}
        IERC20(USDC).safeTransferFrom(p.consumer, address(this), p.fee);
        _recordSip(p.consumer, p.nftId);
        emit PCEBite(p.consumer, p.nftId, p.productHash, p.action, p.timestamp, p.fee, currentNonce);
        emit GeneratorExecuted(signer, p.consumer, p.nftId);
    }

    // Declaration node: NFT_CONTRACT is the market (not ERC721) -> ownerOf reverts by design.
    function claimEarn(uint256 nftId) external nonReentrant notFrozen {
        require(nftId != SACRED_NFT, "Sacred #16");
        require(IERC721(NFT_CONTRACT).ownerOf(nftId) == msg.sender, "Not owner");
        require(mintTimestamp[nftId] == 0, "Already claimed");
        require(sipped[nftId], "Sip required");
        require(sippedBy[nftId] == msg.sender, "Sip not yours");
        uint256 reserve = IERC20(ERC20_OWNER).balanceOf(address(this));
        require(reserve > 0, "Empty reserve");
        uint256 reward = (reserve * ERC20_OWNER_SHARE) / 100;
        mintTimestamp[nftId] = block.timestamp;
        sipped[nftId]   = false;
        sippedBy[nftId] = address(0);
        IERC20(ERC20_OWNER).safeTransfer(msg.sender, reward);
        emit Earned(msg.sender, nftId, reward, IERC20(ERC20_OWNER).balanceOf(address(this)));
    }

    function stitchPCE(address to, uint256 nftId) external onlyRole(SIGNER_ROLE) notFrozen {
        mintTimestamp[nftId] = block.timestamp;
        emit Stitched(to, nftId, "V0");
    }

    function addSigner(address s) external onlyRole(DEFAULT_ADMIN_ROLE) { _grantRole(SIGNER_ROLE, s); }
    function removeSigner(address s) external onlyRole(DEFAULT_ADMIN_ROLE) { _revokeRole(SIGNER_ROLE, s); }
    function emergencyFreeze() external onlyRole(DEFAULT_ADMIN_ROLE) { isFrozen = true; }
    function unfreeze() external onlyRole(DEFAULT_ADMIN_ROLE) { isFrozen = false; }

    event WithdrawnUSDC(address indexed admin, address indexed to, uint256 amount);
    event WithdrawnERC20Owner(address indexed admin, address indexed to, uint256 amount);
    event WithdrawnETH(address indexed admin, address indexed to, uint256 amount);
    event WithdrawnNFT(address indexed admin, address indexed nftToken, address indexed to, uint256 nftId);

    function withdrawUSDC(address to, uint256 amount) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && amount > 0, "Bad args");
        IERC20(USDC).safeTransfer(to, amount);
        emit WithdrawnUSDC(msg.sender, to, amount);
    }

    function withdrawERC20Owner(address to, uint256 amount) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && amount > 0, "Bad args");
        IERC20(ERC20_OWNER).safeTransfer(to, amount);
        emit WithdrawnERC20Owner(msg.sender, to, amount);
    }

    function withdrawETH(address payable to, uint256 amount) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && amount > 0 && address(this).balance >= amount, "Bad args");
        (bool ok,) = to.call{value: amount}("");
        require(ok, "Failed");
        emit WithdrawnETH(msg.sender, to, amount);
    }

    function withdrawNFT(address nftToken, address to, uint256 nftId) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0) && IERC721(nftToken).ownerOf(nftId) == address(this), "Bad args");
        IERC721(nftToken).safeTransferFrom(address(this), to, nftId);
        emit WithdrawnNFT(msg.sender, nftToken, to, nftId);
    }

    function withdrawNFTBatch(address nftToken, address to, uint256[] calldata ids) external nonReentrant onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0), "Zero");
        for (uint i; i < ids.length; i++) {
            require(IERC721(nftToken).ownerOf(ids[i]) == address(this), "Not owner");
            IERC721(nftToken).safeTransferFrom(address(this), to, ids[i]);
            emit WithdrawnNFT(msg.sender, nftToken, to, ids[i]);
        }
    }

    function balanceUSDC() external view returns (uint256) { return IERC20(USDC).balanceOf(address(this)); }
    function balanceERC20Owner() external view returns (uint256) { return IERC20(ERC20_OWNER).balanceOf(address(this)); }
    function balanceETH() external view returns (uint256) { return address(this).balance; }
    function balanceOfNFTs(address t, uint256[] calldata ids) external view returns (bool[] memory) {
        bool[] memory o = new bool[](ids.length);
        for (uint i; i < ids.length; i++) o[i] = IERC721(t).ownerOf(ids[i]) == address(this);
        return o;
    }

    receive() external payable {}
    fallback() external payable {}
}

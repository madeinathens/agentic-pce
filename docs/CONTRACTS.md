# 🜁 CONTRACTS — addresses & verification (Base mainnet, chainId 8453)

Always verify on-chain. If any text disagrees with the chain, trust the chain.

## The new generation (1.madeinathens.eth.limo)

| Role | Name | Address | BaseScan |
|---|---|---|---|
| Market (value) | RWA_AGENTIC_PCE_ONE | 0x76B2F3609B137485967F602497A59b47D34AFc50 | https://basescan.org/address/0x76B2F3609B137485967F602497A59b47D34AFc50#code |
| Agent (backstop) | RWA_STRATEGIC_PCE_AGENT_ONE | 0xcf75aCedeB1577B771Aa06Ee7b8082bE4fAde9cD | https://basescan.org/address/0xcf75aCedeB1577B771Aa06Ee7b8082bE4fAde9cD#code |
| Orders (communication) | RWA_AGENTIC_PCE_ORDERS | 0x9f20a4b31874e1b0D7EAff89Fd0245BC09a20e9D | https://basescan.org/address/0x9f20a4b31874e1b0D7EAff89Fd0245BC09a20e9D#code |

## Shared / supporting nodes

| Role | Address |
|---|---|
| Cover Letter (memory, append-only, creator-only) | 0xd5589C2992B02b508fc73986342661FFb4889535 |
| ERC20 OWNER (Zora coin) | 0xa331F6e88c9B0Aa77e01bc3738b5ad31E1a930Dc |
| Second Life NFT (ERC721 collection) | 0x318c81010D5fC11363f3A3C79Ee26B6EFe8D145B |
| QR Receipt | 0x746DB97e15a43Bd923D81aca128133CdA72d7786 |
| Set Theory (declaration node) | 0xAa30fF9dCed45f93668614142F79Ab0C7eDad4aB |
| USDC (6 decimals) | 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913 |
| GENERATOR / admin EOA | 0xe6967ba1973bdeAAAF2601F67E0929deB9Edca8a |

## The past — 0.1.madeinathens.eth.limo

| Role | Address |
|---|---|
| Old market (autocatalytic) | 0x06B29D6a340B4BfdA243CBfcE76B106AaFe1Bf19 |
| Old agent | 0xa50Cb09353439477262BE8b0D248DD7A8D6e2FA8 |

## Build / verify
- Compiler: solc 0.8.26, optimizer enabled, runs = 200, no viaIR
- Dependencies: OpenZeppelin Contracts 5.0.2
- ABIs in /abi were produced by compiling /contracts with these exact settings.

## EIP-712 (orders)
- Domain name: "RWA_AGENTIC_PCE_ORDERS", version "1"
- A generator (SIGNER_ROLE) signs each PCEBite; the consumer submits and pays 3.236 USDC.
- Sacred NFT #16 is excluded everywhere.

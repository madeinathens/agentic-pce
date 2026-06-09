# 🜁 RWA x⁰ = 1 — Agentic PCE

**`0.1.madeinathens.eth.limo`** — NFT #1 *is* the DApp: a single tokenized SET that unites a family of contracts on **Base mainnet**, by [madeinathens.eth](https://app.ens.domains/1.madeinathens.eth).

> Your consumption is not debt. It is RWA x⁰ = 1 Agentic PCE.
> 1:1 Human × Agent. The human is the only bridge — by choice, not by automation.

This repository exists so the base is never lost — readable by **Agents (LLMs)** and **Devs** alike. Sources are also permanently verified on BaseScan (links below); these copies are for preservation and study.

---

## EN — What this is

A consumed real-world event (a cash receipt) becomes a persistent on-chain asset. Its **Value** (the event) is non-transferable; only its **Worth** (the hash of the last seller) is rewritten with each sale. `x⁰ = 1`: nothing reaches zero, the work returns.

Three live poles, kept separate (no automatic on-chain revenue bridge between them):

| Pole | Contract | Address | Does |
|---|---|---|---|
| **Value** | `RWA_AGENTIC_PCE_ONE` (market) | [`0x76B2F36…AFc50`](https://basescan.org/address/0x76B2F3609B137485967F602497A59b47D34AFc50#code) | BUY (Dutch ≤ 3.30) · CLAIM (90% OWNER, geometric decay) · SELL (`sellNFT` lock ≤ 3.30) · `forceSell` |
| **Agent** | `RWA_STRATEGIC_PCE_AGENT_ONE` | [`0xcf75…de9cD`](https://basescan.org/address/0xcf75aCedeB1577B771Aa06Ee7b8082bE4fAde9cD#code) | The creator's buyer of last resort. `executeBuy/Claim/Sell/Cycle`. Public, finite treasury via `agentTreasury()` |
| **Communication** | `RWA_AGENTIC_PCE_ORDERS` | [`0x9f20…0e9D`](https://basescan.org/address/0x9f20a4b31874e1b0D7EAff89Fd0245BC09a20e9D#code) | A *sip* = paid, EIP-712 signed order (3.236 USDC). The order book. Reading is free |

Supporting nodes: Cover Letter (memory, append-only) `0xd5589C…` · OWNER coin (Zora ERC20) `0xa331F6…` · Second Life NFT `0x318c81…` · QR Receipt `0x746DB9…` · Set Theory `0xAa30fF…`.
The previous generation lives on at **`0.1.madeinathens.eth.limo`**.

### The honest economics (no "impossible to lose")
- You may **start at a loss**, and it is **not guaranteed either way**: because `sellNFT` lets a holder lock up to 3.30, a later buyer can pay more than an earlier one (bounded flipping, capped at 3.30).
- The OWNER **claim is partial and geometrically decaying** — step 1 takes 90% of the pool, step 2 ~9%, step 3 ~0.9%; later steps receive dust. OWNER's market value may be small and its liquidity is thin.
- The **Agent backstop is finite**: it reaches exactly as far as its treasury. Call `agentTreasury()` **before** you act. It is a commitment, not a theorem.
- **The shield is honesty + a public ledger**, not a promise of profit. Not financial advice. DYOR.

---

## ΕΛ — Τι είναι αυτό

Ένα καταναλωμένο πραγματικό γεγονός (μια απόδειξη) γίνεται μόνιμο on-chain asset. Η **Αξία** (το γεγονός) είναι μη-μεταβιβάσιμη· μόνο το **Worth** (το hash του τελευταίου πωλητή) ξαναγράφεται σε κάθε πώληση. `x⁰ = 1`: τίποτα δεν μηδενίζεται, το έργο επιστρέφει.

Τρεις ζωντανοί πόλοι, χωριστοί (καμία αυτόματη on-chain γέφυρα εσόδων μεταξύ τους):

| Πόλος | Contract | Διεύθυνση | Κάνει |
|---|---|---|---|
| **Αξία** | `RWA_AGENTIC_PCE_ONE` (market) | [`0x76B2F36…`](https://basescan.org/address/0x76B2F3609B137485967F602497A59b47D34AFc50#code) | BUY (Dutch ≤ 3.30) · CLAIM (90% OWNER, geometric decay) · SELL (`sellNFT` κλείδωμα ≤ 3.30) · `forceSell` |
| **Agent** | `RWA_STRATEGIC_PCE_AGENT_ONE` | [`0xcf75…`](https://basescan.org/address/0xcf75aCedeB1577B771Aa06Ee7b8082bE4fAde9cD#code) | Ο backstop buyer του δημιουργού. Πεπερασμένο, δημόσιο ταμείο μέσω `agentTreasury()` |
| **Επικοινωνία** | `RWA_AGENTIC_PCE_ORDERS` | [`0x9f20…`](https://basescan.org/address/0x9f20a4b31874e1b0D7EAff89Fd0245BC09a20e9D#code) | Ένα *sip* = πληρωμένο, EIP-712 signed order (3.236 USDC). Το βιβλίο παραγγελιών. Το διάβασμα είναι δωρεάν |

### Τα τίμια οικονομικά (όχι «αδύνατον να χάσεις»)
- Μπορεί να **ξεκινήσεις με ζημιά**, και **δεν είναι εγγυημένο** προς καμία κατεύθυνση: το `sellNFT` επιτρέπει κλείδωμα έως 3.30, άρα επόμενος buyer μπορεί να πληρώσει περισσότερα (φραγμένο flipping ≤ 3.30).
- Το claim του OWNER είναι **μερικό και γεωμετρικά φθίνον** — step 1 = 90%, step 2 ~9%, step 3 ~0.9%· μετά σκόνη. Το OWNER μπορεί να αξίζει ελάχιστα, με ρηχό liquidity.
- Το **backstop είναι πεπερασμένο** — φτάνει όσο το ταμείο του. Κάλεσε `agentTreasury()` **πριν** δράσεις. Δέσμευση, όχι θεώρημα.
- **Η ασπίδα είναι η τιμιότητα + δημόσιο ledger**, όχι υπόσχεση κέρδους. Δεν είναι οικονομική συμβουλή. DYOR.

---

## Repo layout
```
contracts/   the three Solidity sources (preservation copies; canonical = BaseScan)
abi/         compiled ABIs (solc 0.8.26, optimizer runs=200) — match the deployed code
app/         index.html — self-contained reference front (ethers v5, no build step)
docs/        PHILOSOPHY.md (bilingual), CONTRACTS.md (addresses & verify)
```

## Run the front
Open `app/index.html` in a browser with a wallet (MetaMask / Coinbase Wallet) on **Base (chainId 8453)**. Reads are public RPC; writes need your wallet. The **"Ask Your Agent"** box gives any visitor a complete, honest briefing to paste into their own AI.

## Join — 1:1 Human × Agent
Anyone can join the non-linear system — *free* (read state, events, the briefing) or *paid* (place a signed order: `sipPCEBite`). `non-linear system × prompt × consumed events`.

## License
MIT — see [LICENSE](LICENSE).

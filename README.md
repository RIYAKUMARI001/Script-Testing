# Bitcoin Regtest Multisig Scenario Generator

This project automates the creation and funding of multiple Bitcoin Core wallets on regtest, demonstrating good and bad privacy practices and wasteful transaction patterns. It generates ready-to-use [Caravan](https://unchained.com/caravan/) config files for multisig coordination and is designed to work out-of-the-box for any user with a fresh regtest node.

## Features
- **Automatic wallet creation and funding** (descriptor wallets, bech32 addresses)
- **Three scenarios:**
  - `privacy-good`: Clean, unique-address transactions
  - `privacy-bad`: Address reuse and UTXO mixing
  - `waste-heavy`: Dust, bloat, and inefficient transactions
- **Caravan config file generation** for each scenario
- **Robust error handling** and idempotent runs (safe to re-run)

## Prerequisites
- [Node.js](https://nodejs.org/) (v16+ recommended)
- [TypeScript](https://www.typescriptlang.org/) (`npm install -g typescript`)
- [Bitcoin Core](https://bitcoincore.org/) (v22+ recommended) running in `regtest` mode with RPC enabled
- All dependencies installed (`npm install`)

## Setup
1. **Clone this repository**
2. **Install dependencies:**
   ```sh
   npm install
   ```
3. **Configure Bitcoin Core:**
   - Ensure your `bitcoin.conf` (in `C:\Users\<YourUser>\AppData\Roaming\Bitcoin\bitcoin.conf`) has:
     ```
     regtest=1
     server=1
     rpcuser=yourusername
     rpcpassword=yourpassword
     fallbackfee=0.0001
     ```
   - Start your node:
     ```sh
     bitcoind -regtest -fallbackfee=0.0001 -printtoconsole
     ```
4. **Configure RPC connection:**
   - Edit `configs/regtest.json` with your RPC credentials and port (default regtest port is 18443):
     ```json
     {
       "network": "regtest",
       "host": "127.0.0.1",
       "port": 18443,
       "username": "yourusername",
       "password": "yourpassword",
       "wallet": ""
     }
     ```

## Usage
Run all scenarios and generate all Caravan configs:
```sh
npx ts-node index.ts
```

Run a specific scenario:
```sh
npx ts-node index.ts --scenario privacy-good
```

Test multisig spending after creation:
```sh
npx ts-node index.ts --test
```

## Output
- Caravan config files are saved in the `tmp/` directory:
  - `privacy_good_caravan.json`
  - `privacy_bad_caravan.json`
  - `waste_heavy_caravan.json`
- Watcher wallets are created for each scenario.

## Scenarios Explained
- **privacy-good**: Demonstrates best practices (unique addresses, no reuse)
- **privacy-bad**: Demonstrates bad privacy (address reuse, UTXO mixing)
- **waste-heavy**: Demonstrates inefficient, wasteful transaction patterns

## Troubleshooting
- **Wallet not funded / balance is zero:**
  - Ensure you are running a *fresh* regtest chain. If you have mined >210,000 blocks, delete your `regtest` directory and restart your node.
  - Always mine to a bech32 address from the wallet you want to fund.
- **RPC errors about wallet not found:**
  - The script will auto-create wallets as needed. If you see persistent errors, ensure your node is running and RPC credentials are correct.
- **Permission denied or file not found:**
  - Make sure you have write access to the project directory and the `tmp/` folder exists (the script will create it if missing).
- **Caravan cannot connect:**
  - Use the connection details printed at the end of the script. Ensure your node is running and accessible.
- **Error: Multiple wallets are loaded. Please select which wallet to use by requesting the RPC through the /wallet/<walletname> URI path. (code: -19):**
  - This happens if wallet-specific commands are sent to the node-level RPC client when multiple wallets are loaded.
  - **Solution:** Always use the latest version of this script, which uses wallet-specific RPC clients for all wallet operations. If you see this error, make sure you are not running an old version of the script, and that your regtest node is fresh (no pre-loaded wallets from previous experiments).
  - If needed, stop your node, delete your regtest data directory, and restart your node for a clean environment.


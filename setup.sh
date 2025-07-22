#!/bin/bash

echo "🚀 Setting up Bitcoin Multisig Caravan Wallets..."
echo "=================================================="

# Check if Bitcoin Core is running
if ! curl -s --user caravanuser:caravanpass --data-binary '{"jsonrpc":"1.0","id":"test","method":"getblockchaininfo","params":[]}' -H 'content-type: text/plain;' http://localhost:8080/ > /dev/null 2>&1; then
    echo "❌ Bitcoin Core is not running or not accessible"
    echo "Please start Bitcoin Core in regtest mode:"
    echo "bitcoind -regtest -server -rpcuser=caravanuser -rpcpassword=caravanpass -rpcport=8080"
    exit 1
fi

echo "✅ Bitcoin Core is running"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Run the setup
echo "🏗️  Creating multisig wallets..."
npx ts-node index.ts --scenario=all

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📁 Generated files:"
echo "   - tmp/privacy_good_caravan.json"
echo "   - tmp/privacy_bad_caravan.json" 
echo "   - tmp/waste_heavy_caravan.json"
echo ""
echo "🎯 Next steps:"
echo "   1. Open Caravan Coordinator"
echo "   2. Import the config files from tmp/ folder"
echo "   3. Connect to http://localhost:8080"
echo "   4. You should see funded wallets!"
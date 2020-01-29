#!/bin/bash
set -ex
nodeType="${NODETYPE:-fullnode}"
bnet="${BNET:-testnet}"

mkdir -p ${BNCHOME}/config/
chown -R bnbchaind:bnbchaind ${BNCHOME}/config/

if [ "$nodeType" == "fullnode" ]; then
  if [ "$bnet" == "prod" ]; then
    cp /node-binary/fullnode/prod/${BVER}/config/* ${BNCHOME}/config/
  fi
  if [ "$bnet" == "testnet" ]; then
    cp /node-binary/fullnode/testnet/${BVER}/config/* ${BNCHOME}/config/
  fi
  # Turn on console logging
  sed -i 's/logToConsole = false/logToConsole = true/g' ${BNCHOME}/config/app.toml
  EXECUTABLE='/usr/local/bin/bnbchaind start --home '${BNCHOME}
fi

if [ "$nodeType" == "lightnode" ]; then
  chainName="${CHAIN_NAME:-Binance-Chain-Nile}"
  peerNode=data-seed-pre-0-s1.binance.org:80
  if [ $bnet == "prod" ]; then
    chainName=Binance-Chain-Tigris
    peerNode=dataseed1.binance.org:80
  fi
  EXECUTABLE='/usr/local/bin/lightd --chain-id '$chainName' --node tcp://'$peerNode' --laddr tcp://0.0.0.0:27147'
fi

echo "Running $EXECUTABLE in $PWD"
sleep 5
$EXECUTABLE

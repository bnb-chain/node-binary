# Binance Chain Client

:rocket: Important Note: BNB Beacon Chain is opensoured, and binary and config files are released in the [source code repo](https://github.com/bnb-chain/node). Please visit [it](https://github.com/bnb-chain/node/releases) to get the lastest updates, and this repo will stop updating reated files.

[Binance Chain](https://www.binance.org/) is a blockchain developed by Binance and its community, that focuses on building a performant matching engine and exchange over a decentralized network.

- [Match logic](https://docs.binance.org/match.html)
- [Anti-front running](https://docs.binance.org/anti-frontrun.html)

Binance Chain clients are released as compiled executables in this repo, with a few variants:

- [Full Node](https://docs.bnbchain.org/docs/validator/fullnode): downloads full blockchain and relays transactions
- [Light Client](https://docs.bnbchain.org/docs/beaconchain/light-client/): does not sync state or relay transactions

For more on which client to run, see [Light Client vs Full Node](https://docs.bnbchain.org/docs/beaconchain/light-client/#light-client-versus-full-node).

## Installation Script

We have a community-maintained installer script (`install.sh`) that takes care of chain directory setup. This uses the following defaults:

- Home folder in `~/.bnbchaind`
- Client executables stored in `/usr/local/bin` (i.e. `light` or `bnbchaind`)

```shell
# One-line install
sh <(wget -qO- https://raw.githubusercontent.com/onggunhao/node-binary/master/install.sh)
```

> In the future, we may release an official installer script  
> e.g. `sh <(wget -qO- https://get.binance.org)`

## Docker node

### Building locally

```
git clone https://github.com/binance-chain/node-binary.git
cd node-binary/docker && docker build . -t binance/binance-node
```

### Run interactively

`docker run --rm -it --ulimit nofile=16000:16000 binance/binance-node`

### Run as daemon

```
ufw allow 27146/tcp
docker run -d --name binance-node -v binance-data:/opt/bnbchaind -e "BNET=prod" -p 27146:27146 -p 27147:27147 -p 26660:26660 --restart unless-stopped --security-opt no-new-privileges --ulimit nofile=16000:16000 binance/binance-node
```

For more details see README.md in the docker directory.

## Manual Installation

We currently use this repo to store historical versions of the compiled `node-binaries`.

### Running a Full Node

- Step-by-step tutorial at [full node docs](https://docs.bnbchain.org/docs/beaconchain/develop/node/join-mainnet)
- [Common issues when running a full node](https://docs.bnbchain.org/docs/beaconchain/develop/node/fullnodeissue)

### Running a Light Client

- Step-by-step tutorial at [light client docs](https://docs.bnbchain.org/docs/beaconchain/light-client/#light-client-versus-full-node)

## Uninstalling

- Delete the `~/bnbchaind` directory and subdirectories
- Delete the `bnbchaind` or `lightd` executable

_**Example**: If you installed using installation script_:

```
rm -rf ~/.bnbchaind
rm /usr/local/bin/lightd
rm /usr/local/bin/bnbchaind
```

### Common Issues and Solutions

https://docs.bnbchain.org/docs/beaconchain/develop/node/fullnodeissue

# Tools

1. [Airdrop Tool](https://github.com/binance-chain/chain-tooling#airdrop)
2. [Token Issue&Listing GUI](https://github.com/binance-chain/chain-tooling/tree/airdrop/token-app)

## Resrouces

- [Dos Site](https://docs.bnbchain.org/)
- [Wallet](https://docs.bnbchain.org/docs/beaconchain/wallets)

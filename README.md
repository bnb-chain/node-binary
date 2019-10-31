# Binance Chain Client

[Binance Chain](https://www.binance.org/) is a blockchain developed by Binance and its community, that focuses on building a performant matching engine and exchange over a decentralized network. 

* [Match logic](https://docs.binance.org/match.html)
* [Anti-front running](https://docs.binance.org/anti-frontrun.html)

Binance Chain clients are released as compiled executables in this repo, with a few variants:

* [Full Node](https://docs.binance.org/fullnode.html): downloads full blockchain and relays transactions
* [Light Client](https://docs.binance.org/light-client.html): does not sync state or relay transactions

For more on which client to run, see [Light Client vs Full Node](https://docs.binance.org/light-client.html#light-client-versus-full-node).

## Installation Script

We have a community-maintained installer script (`install.sh`) that takes care of chain directory setup. This uses the following defaults:

* Home folder in `~/.bnbchaind`
* Client executables stored in `/usr/local/bin` (i.e. `light` or `bnbchaind`)

```shell
# One-line install
wget https://raw.githubusercontent.com/onggunhao/node-binary/master/install.sh | sh
```

> In the future, we may release an official installer script  
> e.g. `wget https://get.binance.org | sh`

## Manual Installation

We currently use this repo to store historical versions of the compiled `node-binaries`.

### Running a Full Node

* Step-by-step tutorial at [full node docs](https://docs.binance.org/fullnode.html)
* [Common issues when running a full node](https://docs.binance.org/fullnodeissue.html#common-issues-when-running-a-full-node)

### Running a Light Client

* Step-by-step tutorial at [light client docs](https://docs.binance.org/light-client.html#light-client-versus-full-node)

## Uninstalling

* Delete the `~/bnbchaind` directory and subdirectories
* Delete the `bnbchaind` or `lightd` executable

_**Example**: If you installed using installation script_:
```
rm -rf ~/.bnbchaind
rm /usr/local/bin/lightd
rm /usr/local/bin/bnbchaind
```

# Changelog

## 0.6.1
*Jul 22th*
**New Features**
* Introduce Customized Scripts and Transfer Memo Validation
* Add `--dry` flag in `bnbcli` to get encoded signed transaction in hex

**Bug Fixes**
* Add chain-id check for sign command

**Tendermint Changes**

* More configuration in config file
* More P2P metrics


## 0.6.0
*June 26th*

**New Features**

* Delist Trading Pairs on Binance DEX
* Time Locking of Token Assets on Binance Chain
* Registered Types for Transaction Source
* State Sync Enhancement
* Match Engine Revise

**Bug Fixes**

* Apply more validity check on the fee-change proposals

**Tendermint Changes**

Binance chain bumped its Tendermint dependency from v0.30.1 to v0.31.5.

* Other improvements:
  * The stability of P2P layer is improved. Now, it handles high pressure better when state-sync; handle DNS lockup failure；dataseed nodes dials more efficiently
  * RPC response time is decreased
  * issues in go-crypto are fixed

## 0.5.10
*June 13th*

**Imoprovements**
* Fix  issues with AppHash conflicts when running `state-sync`

## 0.5.9

*May 28th*

**Imoprovements**

* Support asynchronously handling websocket requests
* Fix minor issues to improve stablity

## 0.5.8

*April 18th*

This is the first public release of Binance Chain Full node for testnet

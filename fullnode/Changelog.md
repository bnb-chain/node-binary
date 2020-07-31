# Changelog

## 0.7.2-bsc.beta.3

*July. 31rd*

Add minor changes

## 0.7.2-bsc.beta.2-hf.1

*July. 27rd*

**Bug Fix**

* Fix node crash when node failed to load block from db after state sync.
* Fix `latest_block_height` of status api do not update after switch to `hot-sync`.

## 0.7.2-bsc.beta.2

*July. 23rd*

**New Features**

* Staking features for Binance Smart Chain

## 0.7.1

**Bug Fix**
* Fix bugs with delist


## 0.7.0
*June. 3rd*

**New Features**

* BEP8 - Mini-BEP2 token features
* BEP70 - Support busd pair listing and trading

Improvements
* BEP67 Price-based Order Expiration
* Add pendingMatch flag to orderbook query response

## 0.6.3-hf.2
*June. 1st*

**Bug Fix**
* Fix bugs with replaying blocks

## 0.6.3-hf.1
*Nov. 21th*

**Bug Fix**
* Fix bugs with multisend

## 0.6.3
*Nov. 11th*

**New Features**
* Expose kafka version in publisher setting

**Improvements**
* Lot Size enhencement
* Change constrains of listing transaction
* Massive performance improvements,  especially for storage.
* Improve the handle of zero balance accounts

**Tendermint Changes**
Due to changes of underling Tendermint library, `ResponseCheckTx`, `ResponseDeliverTx`, `ResponseBeginBlock`, and `ResponseEndBlock` now include `Events` instead of `Tags`. Each Event contains a type and a list of attributes (list of key-value pairs) allowing for inclusion of multiple distinct events in each response.

## 0.6.2
*Sep 12th*

** New Features**

* BEP3, atomic swap
* Add memo to transfer kafka message
* Improve the handle of Kafka server connection error
* API Server Improvements: Add support for querying time-lock information.

**Tendermint Changes**

* Introduce Hot-Sync
* Support Index service recovery and add indexHeight in Status api
* Performance improvements

## 0.6.1-hotfix
*Sep 3rd*
**Bug Fix**
*  [\#109](https://github.com/binance-chain/node-binary/issues/109)fix can't bring bnbchaind back when there is an order whose symbol is lower case

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

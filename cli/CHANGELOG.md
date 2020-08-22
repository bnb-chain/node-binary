# Changelog

## 0.8.0
*Aug 23th*
 **New Feature**
* BNB Staking
* Cross-chain transfer
* On-chain governance

## 0.7.0
*June. 3rd*

**New Features**

* BEP8 - Mini-BEP2 token features
* BEP70 - Support busd pair listing and trading

Improvements
* BEP67 Price-based Order Expiration

## 0.6.3
*Nov 11th*
 **New Feature**
* Performance Improvements

## 0.6.2-TSS
*Nov 5th*

**New Feature**
* Add Threshold Signature Scheme (TSS) support v0.1.2


## 0.6.2
*Sept 12th*

**New Feature**
* Add more checks on account flag commands
* Add levels parameter to depth ABCI query
* Fix the issue of generating order-id in offline mode

## 0.6.1-TSS
*Aug 27th*
 **New Feature**
* Add Threshold Signature Scheme (TSS) support:
1. To add a tss key into bnbcli’s keystore:
Tss keygen command will automatically add generated secret share into default keystore (~/.bnbcli) with name “tss_<moniker>_<vault_name>”
2. User can manually specify tss’s home, vault_name and a customized bnbcli home like:
```
bnbcli keys add --home ~/.customized_cli --tss -t tss --tss-home ~/.test1 --tss-vault “default” my_name
```

## First Release of TSS Binary

This is the first release of Threshold Signature Scheme (TSS) binaries. You can take a look at the [user guide](./testnet/0.6.1-TSS/TSSUserGuide.md) first.


## 0.6.1
*Aug 5th*
 **New Feature**
* Add `memo-check`function
* Add transaction hex generation

## 0.6.0

*June 26th*

**New Feature**
* Offline Transactions Signing: `bnbcli` support generating and signing all types of transactions offline, then broadcast them. This feature will let users generate and sign their transactions at an offline machine, then use another machine to broadcast it to the network

## 0.5.8.1

*April 24th*

This is the second public release of Binance Chain Client for mainnet and testnet.


**Feature**
* Add ledger support

## 0.5.8

*April 23th*

This is the first public release of Binance Chain Client for mainnet.

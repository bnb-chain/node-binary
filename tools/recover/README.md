# State Recover

The Binance Chain has a hardfork upgrade and if you failed to upgrade your fullnode to the latest version, `bnbchaind` process will stop and even if you restart with the latest version, the following error will appear:
```
panic: Tendermint state.AppHash does not match AppHash after replay. Got , expected 393887B67F69B19CAB5C48FB87B4966018ABA893FB3FFD241C0A94D2C8668DD2
goroutine 1 [running]:
github.com/binance-chain/node/vendor/github.com/tendermint/tendermint/consensus.checkAppHash(0xa, 0x0, 0xc000bd8c56, 0x6, 0xc000b247c0, 0x12, 0x14e7bf9, 0x8592eb, 0xc000b247e0, 0x20, ...)
/Users/huangsuyu/go/src/github.com/binance-chain/node/vendor/github.com/tendermint/tendermint/consensus/replay.go:464 +0x213
github.com/binance-chain/node/vendor/github.com/tendermint/tendermint/consensus.(*Handshaker).ReplayBlocks(0xc000b37980, 0xa, 0x0, 0xc000bd8c56, 0x6, 0xc000b247c0, 0x12, 0x14e7bf9, 0x8592eb, 0xc000b247e0, ...)
```

To recover from the `state` conflict error, you need to:

* Backup your home directory,  (default is ~/.bnbchaind)

* Download the tool: `state-recover`

* Get the height of upgrade, this height will be announced in the upgrade announcement on the forum.  For example, if it's announced as 5000 in the forum and run the following command will make your full node recover to the last block before the upgrade, and that is 4999 :
```
./state_recover 4999 <your_home_path>
```

* Restart with the latest version of `bnbchaind`

```
bnbchaind start --pruning breathe&
```

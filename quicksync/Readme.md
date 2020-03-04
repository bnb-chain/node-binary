# Fast replay

Binance chain team provide a snapshot data of all history blocks and state for downloading. Full nodes can replay blocks locally without verification after downloading the data.

## Replay Step
- Download snapshot from the [url](https://s3.ap-northeast-1.amazonaws.com/dex-bin.bnbstatic.com/chain-analisis-download-data/server-bnbchaind-disaster-node-gaiad-data.zip?AWSAccessKeyId=ASIAYINE6SBQKG4SGLJW&Expires=1609247337&x-amz-security-token=IQoJb3JpZ2luX2VjEIX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLW5vcnRoZWFzdC0xIkYwRAIgU3v5TNgme1kRb%2FWhNRtQXPTepaCUVy2GIdh9ZUpQjOECIBvzF3RU2u9mnrbagEHKdSXlkcYkTuFczbYI8sRCJgtCKr4DCF4QARoMNTY3ODE4NDg5OTUyIgwOqmbmpA0dKZpX12UqmwMKGTuT%2FUcAdFdRyz4gifUh2aBbePT%2F7ubPkygZ7pMpYGJrqd90ZQjpkZaSqVTKnUrKNt7kvElij1HTakf8nyo9yLmJzNu2y6d%2FNLdGaOHZ3ie14mMs9XRwXr%2BhhjZKSUQ4zA1lgU%2FxiZDIzKS%2BSQu5JeKZGqtkCUrqJZpluuB2fvvlQw5PhNMtL%2FM0qzQbvNootsFTQ7gLFzopRODGmPDFyfoh17nF0If7wb9O0KPi24W45llzrpEfPi2vTyUHUgBHxlDDiUWYSxuFQhP1%2BfjLGHC4jR3H6WCXgq1ASYsLxP08EGpOLtwcPh%2F%2FTXXGbKYvHWwvE9mb3nyB2RFa12KvG2nZU2Agi1h%2FT0sOtW3T7fRl0Cc2jNTlK4iNPEzm%2FQT6T3gCTNLLS7ohatA6xtg25QcKL2t8%2FfAF7uwCqdiXE%2BYVwwRyWH1kbu96DBF%2FaAh6BzXTH34FiepbG96vj1NSs82ydXYVaiCmO4oB5%2FigCaDGNhXabytcFyt2PaVgTUzIatJ2tzGkhX7qeFrr448jgad%2BBmQFliiDP38w38P%2B8gU67AGj58AcvD0IOb%2BSZjmbZ3SHGuG70DgsslPpjNSgfUm3zRtM1GLZT4Nx%2BSTL8XLk%2FWILL18Ll7WGEDt8GfTPwrVqP8v6l3ghumzfJ9Yibe%2FQfMO7%2BGdV1YC7LAiM9nOFpX6YdoIpmkY3XYRdniPV3cfSC%2BmEl9eyCwyTiWpuTZRguvNc05DubICthjrF1OYUmYfNz4pgEgc3fFWx9%2BiForS3tF6nj0LUxFKoh7NcPVkhs%2Betggc857S1tMATTkCcbjFGe65G79jLr1IDM%2Bs3C5%2BA2%2FQn0oDXKcWH0Txu38Yc3ssyBTNRSbi0ptD1PQ%3D%3D&Signature=WXJncbFSanMijSs0vn2ae1qJ9Lc%3D) provided by binance team and unzip it into the ${chain-home}/data. You can download by `nohup curl ${the download url} > data.zip &`.  
- Download new binary from current [page](https://github.com/binance-chain/node-binary/blob/quicksync/quicksync/bnbchaind). 
- Modify the config `with_app_stat = true` of ${chain-home}/config/config.toml into `with_app_stat = false`.
- Modify all the config `indexer = "kv"` of ${chain-home}/config/config.toml into `indexer = "null"`. 
- Modify the config `state_sync_reactor = true` of ${chain-home}/config/config.toml into `state_sync_reactor = false`.
- Backup the state DB by `mv ${chain-home}/data/application.db ${chain-home}/data/application.db_backup`. This operation only need do once.
- Start node by `nohup ./bnbchaind start --iavl-mock  true   --home ${your-chain-home}  &`.  
- Each time to replay from genesis again, please do `rm -rf ${chain-home}/data/application.db ${chain-home}/data/cs.wal ` before starting the binary.

## What to do after finish replaying blocks 
Once the replay finish, the process will stop automatically.

- Replace the binary of the official one.
- Recover the state DB by `mv ${chain-home}/data/application.db_backup ${chain-home}/data/application.db`. 
- Modify the config `with_app_stat = false` of ${chain-home}/config/config.toml into `with_app_stat = true`.
- start node by `nohup ./bnbchaind start --home ${your-chain-home} &`


## Difference between new binary and official one:
- Merkle tree implement is replaced by memory DB.
- No root hash verification, no basic verification for tx, no signature verification.
- No snapshot at breath block.
- No replay of validatorSet change.

## Test result:
- **Hardware**: 8core,32G linux
- **Main-net**
- **QA-net**
  - **Settings**: local publisher with all topic, replay 2000000 blocks, the number of tx is 2676645
  - **Result**: It takes 54 minutes, the average speed is 617 block/seconds. When there are 50 txs in one block, the speed is about 140 blocks/second. If the block is empty, the speed is about 625 blocks/second.


## Suggestion:

- Local publisher is a better choice than Kafka publisher. The local file of the local publisher can compress and rotate according to the config  `localMaxSize` and `localMaxAge` of ${chain-home}/config/app.toml, so the size of the local file won't be an issue, and the data can be reused. The binance chain client takes around 7ms to publish a Kafka message when the Kafka cluster contains 3 nodes. Because the `ack` of Kafka needs all isr to confirm, which may become the bottleneck. If Kafka is essential, then a single node Kafka will improve the performance.
- As it use memory DB to store state, a VM with large memory will help.




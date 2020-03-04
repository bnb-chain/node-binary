# Solution to speed up sync

Binance chain team provide a snapshot data of all history blocks and state for downloading. Full nodes can replay blocks locally without verification after downloading the data.

## Replay Step
- Download snapshot from the url provided by binance team and unzip it into the ${chain-home}/data.
- Download new binary from current page. 
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

## Test result:
- **Hardware**: 8core,32G linux
- **Settings**: local publisher with all topic, replay 2000000 blocks, the number of tx is 2676645
- **Result**: It takes 54 minutes, the average speed is 617 block/seconds. When there are 50 txs in one block, the speed is about 140 blocks/second. If the block is empty, the speed is about 625 blocks/second.


## Suggestion:

- Local publisher is a better choice than Kafka publisher. The local file of the local publisher can compress and rotate according to the config  `localMaxSize` and `localMaxAge` of ${chain-home}/config/app.toml, so the size of the local file won't be an issue, and the data can be reused. The binance chain client takes around 7ms to publish a Kafka message when the Kafka cluster contains 3 nodes. Because the `ack` of Kafka needs all isr to confirm, which may become the bottleneck. If Kafka is essential, then a single node Kafka will improve the performance.
- As it use memory DB to store state, a VM with large memory will help.




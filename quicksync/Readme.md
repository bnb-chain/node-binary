# Solution to speed up sync
## Main idea

Binance chain team provide a snapshot data of all history blocks and state for downloading. Full nodes can replay blocks locally without verification after downloading the data.

## Replay Step
1. Download snapshot from  and unzip it into the ${chain-home}/data.
2. Download new binary from current page. 
3. Modify the config `with_app_stat = true` of ${chain-home}/config/config.toml into `with_app_stat = false`.
4. Modify all the config `indexer = "kv"` of ${chain-home}/config/config.toml into `indexer = "null"`. 
5. Backup the state DB by `mv ${chain-home}/data/application.db ${chain-home}/data/application.db_backup`. This operation only need do once.
6. Start node by `nohup ./bnbchaind start --iavl-mock  true   --home ${your-chain-home}  &`.  
7. Each time to replay from genesis again, please do `rm -rf ${chain-home}/data/application.db ${chain-home}/data/cs.wal ` before starting the binary.

## What to do after replay finish
Once the replay finish, the process will stop automatically.

1. Replace the binary of the official one.
2. Recover the state DB by `mv ${chain-home}/data/application.db_backup ${chain-home}/data/application.db`. 
3. Modify the config `with_app_stat = false` of ${chain-home}/config/config.toml into `with_app_stat = true`.
4. start node by `nohup ./bnbchaind start --home ${your-chain-home} &`


## Difference between new binary and official one:
1. Merkle tree implement is replaced by memory DB.
2. No root hash verification, no basic verification for tx, no signature verification.
3. No snapshot at breath block.

## Benchmark result:
Hardware: 8core,32G linux
Setting: local publisher with all topic, replay 2000000 blocks, the number of tx is 2676645
Result: It takes 54 minutes, the average speed is 617 block/seconds. When there are 50 txs in one block, the speed is about 140 blocks/second. If the block is empty, the speed is about 625 blocks/second.


## Suggestion:

1. Local publisher is a better choice than Kafka publisher. The local file of the local publisher can compress and rotate according to the config  `localMaxSize` and `localMaxAge` of ${chain-home}/config/app.toml, so the size of the local file won't be an issue, and the data can be reused. The binance chain client takes around 7ms to publish a Kafka message when the Kafka cluster contains 3 nodes. Because the `ack` of Kafka needs all isr to confirm, which may become the bottleneck. If Kafka is essential, then a single node Kafka will improve the performance.
2. As it use memory DB to store state, a VM with large memory will help.




# Fast replay

Binance chain team provide a snapshot data of all history blocks and state for downloading. Full nodes can replay blocks locally without verification after downloading the data.

## Before start
Some suggestions before using the tool:
- Local publisher is a better choice than Kafka publisher. The local file of the local publisher can compress and rotate according to the config  `localMaxSize` and `localMaxAge` of ${chain-home}/config/app.toml, so the size of the local file won't be an issue, and the data can be reused. The binance chain client takes around 7ms to publish a Kafka message when the Kafka cluster contains 3 nodes. Because the `ack` of Kafka needs all isr to confirm, which may become the bottleneck. If Kafka is essential, then a single node Kafka will improve the performance.
- As it use memory DB to store state, a VM with large memory will help.

## Step
- Download snapshot from the [url](https://s3.ap-northeast-1.amazonaws.com/dex-bin.bnbstatic.com/chain-analisis-download-data/server-bnbchaind-disaster-node-gaiad-data.zip\?AWSAccessKeyId\=ASIAYINE6SBQNGQKSYFP\&Expires\=1599745007\&x-amz-security-token\=IQoJb3JpZ2luX2VjEHUaDmFwLW5vcnRoZWFzdC0xIkgwRgIhAMLv6Y91z1aktYYZ88C%2B9g3ziCX5BIRcxZhQKDqUjEzgAiEA0947HlYCXPSn2q8lfFNnN82DSrST%2FF%2Bb5lNh5afAlgoqvgMIXhABGgw1Njc4MTg0ODk5NTIiDHq5KXRiV%2FRnCsP50CqbA1B0c4r%2FFiF4W1Ar%2BTooyMSvpUuhD33UljqOFecaxgHHtR2KOGMjC6%2BVVaIH1%2FmIoCCSlgechahJ9utB0r22zDSYZ5Qf8j8o07HMhyhEAhJe47msbrM5F2GDozvsaVPv4NU6enqSTwvaHrrKT7rKHro5m0xAfKYyEsq6VPdCgEkrzvqM%2BEkkIXa0NDlFIvL3NNlHHwULo0gQlVWgZqt4LoBK6Mdh4SE9Sg%2FcdS29Ymzm6KrA8XsJgKzjunAfgr4tVfNv8gHFh1CkfMqdici9RGPA0CG1nF%2B%2B58yJVm6%2BdlXR%2Fp7LFKVrsRcDQvMzd3IjIxT61Hmp%2BqLgE29ss1bpqdupgOWiU20YxAJlLd83Dy%2BpRGqcqQUw9sty7xH1WE1oFEjUOc1gZv0C3IvN31ZVos65aXaB5Nb4X834pYK4ko83XS%2Fv1JIfuVyqrasUkVoLTTTWDhyPU%2FwXfO1HWxMT18WBZVver%2BxszJF%2F65bp19mOjyKd3MlI7RgYu8W3kPf9u6Dhck%2BXa3ViAgfmlkF%2BkzBv0GW8kTl1PeALbTDEorPzBTrqAQpTpoxmHHS1NuR52sAwcFHF1zG53vDXInCoVv0PADrJarQst2GfgI7hCwlg9MWhQAd1aUEb9vJxlXAtBTHn8OLbxJxLjNHLlrnRJ3m8BecT%2FJM%2FbcwD9U7Itz7zvga44nI2bpo12Cow7GsXpjlzTw1KKvNrUxqCitlAPCiDbrSfEAdqOBU31DnuE1TKQNX708d0GsJOFmxBczLQbRq0WIM5DDM0DiklFrRa%2Bf%2BQM4h2yIQwdWXj2f1qlRiizdPW8DIsH%2BsyT5ADySgJmg9pU2b91bx3RnaKPYHRpa34KT42OQZMUxSg72sBqQ%3D%3D\&Signature\=PZ9pPJxiE8DAUVpUAIE7CLWqHV8%3D) provided by binance team and unzip it into the ${chain-home}/data. You can download by `nohup curl ${the download url} > data.zip &`.  
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
    - **Settings**: local publisher with all topic, replay 17927253 blocks, the number of tx is 3686353
    - **Result**: It takes 574 minutes, the the average speed is 520 blocks/seconds.  
- **QA-net**
  - **Settings**: local publisher with all topic, replay 2000000 blocks, the number of tx is 2676645
  - **Result**: It takes 54 minutes, the average speed is 617 block/seconds. When there are 50 txs in one block, the speed is about 140 blocks/second. If the block is empty, the speed is about 625 blocks/second.





# binance-node-docker

[Binance full node docs](https://docs.binance.org/fullnode.html#run-full-node-to-join-binance-chain)  
[Binance full node repo](https://github.com/binance-chain/node-binary)

Docker image for Binance Full Node  

### Features:

* Spin up full Binance node with single command.
* Works for testnet, prod, or both at once.
* Small image about 100MB, compared to bigger than 6 GB official repository.
* Easy updates

## Building locally

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

You can run both testnet and prod at once, use `-p 27147:27147` for publishing RPC port for one of them.

### Check logs

`docker logs -f binance-node`

### CLI access

 ```
 docker exec -it binance-node /bin/bash
 tbnbcli version
 ```

 use `tbnbcli` for testnet and `bnbcli` for prod

### Update

`docker stop binance-node && docker rm binance-node`, pull fresh image with `docker pull binance/binance-node` and then run again, data and configs in the volume `binance-data` are preserved.

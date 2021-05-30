FROM ubuntu 

# Dockerfile for running Binance node from binary packages under docker
# https://docs.binance.org/fullnode.html#run-full-node-to-join-binance-chain
# MIT license
LABEL Maintainer="Evgeny Varnavskiy <varnavruz@gmail.com>"
LABEL Maintainer="Jacob Gadikian <jacobgadikian@gmail.com>"
LABEL Description="Docker image for Binance full and light nodes"
LABEL License="MIT License"


ENV BNCHOME=/opt/bnbchaind
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget binutils
RUN	wget -O /usr/bin/bnbchaind https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/0.8.2/linux/bnbchaind
RUN mkdir -p /opt/bnbchaind/config && \
    wget -O /opt/bnbchaind/config/app.toml https://github.com/binance-chain/node-binary/raw/master/fullnode/prod/0.8.2/config/app.toml && \
    wget -O /opt/bnbchaind/config/config.toml https://github.com/binance-chain/node-binary/raw/master/fullnode/prod/0.8.2/config/config.toml && \
    wget -O /opt/bnbchaind/config/genesis.json https://github.com/binance-chain/node-binary/raw/master/fullnode/prod/0.8.2/config/genesis.json  
  
  
VOLUME /opt/bnbchaind

# RPC service listen on port 27147 and P2P service listens on port 27146 by default.
# Prometheus is enabled on port 26660 by default, and the endpoint is /metrics.

EXPOSE 27146 27147 26660

CMD ["bnbchaind start"]

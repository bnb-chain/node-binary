# UPDATE ME when new version is out !!!!
ARG BVER_TESTNET=0.8.2
ARG CLIVER_TESTNET=0.8.2
ARG BVER_PROD=0.8.2
ARG CLIVER_PROD=0.8.2
FROM ubuntu:18.04 as builder

# Dockerfile for running Binance node from binary packages under docker
# https://docs.binance.org/fullnode.html#run-full-node-to-join-binance-chain
# MIT license
LABEL Maintainer = "Evgeny Varnavskiy <varnavruz@gmail.com>"
LABEL Description="Docker image for Binance full and light nodes"
LABEL License="MIT License"

ARG DEBIAN_FRONTEND=noninteractive

ARG BVER_TESTNET
ARG CLIVER_TESTNET
ARG BVER_PROD
ARG CLIVER_PROD
ARG NODETYPE=fullnode
#ARG NODETYPE=lightnode

RUN apt-get update && apt-get install -y --no-install-recommends upx ca-certificates wget git git-lfs binutils
RUN	git lfs clone --depth 1 https://github.com/binance-chain/node-binary.git

# RUN upx /node-binary/cli/testnet/${CLIVER}/linux/tbnbcli \
# && upx /node-binary/cli/prod/${CLIVER}/linux/bnbcli \
# && upx /node-binary/${NODETYPE}/testnet/${BVER}/linux/bnbchaind \
# && upx /node-binary/${NODETYPE}/prod/${BVER}/linux/bnbchaind

# Final stage

FROM ubuntu:18.04

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

ARG BVER_TESTNET
ARG CLIVER_TESTNET
ARG BVER_PROD
ARG CLIVER_PROD
ENV BVER_TESTNET=$BVER_TESTNET
ENV CLIVER_TESTNET=$CLIVER_TESTNET
ENV BVER_PROD=$BVER_PROD
ENV CLIVER_PROD=$CLIVER_PROD

ARG NODETYPE=fullnode
#ARG NODETYPE=lightnode
ENV BNET=testnet
#ENV BNET=prod
ENV BNCHOME=/opt/bnbchaind

COPY --from=builder /node-binary/cli/testnet/${CLIVER_TESTNET}/linux/tbnbcli /node-binary/cli/testnet/${BVER}/linux/
COPY --from=builder /node-binary/cli/prod/${CLIVER_PROD}/linux/bnbcli /node-binary/cli/prod/${BVER}/linux/
COPY --from=builder /node-binary/${NODETYPE}/testnet/${BVER_TESTNET}/linux/bnbchaind /node-binary/fullnode/testnet/${BVER}/linux/
COPY --from=builder /node-binary/${NODETYPE}/prod/${BVER_PROD}/linux/bnbchaind /node-binary/fullnode/prod/${BVER}/linux/
COPY --from=builder /node-binary/${NODETYPE}/testnet/${BVER_TESTNET}/config/* /node-binary/fullnode/testnet/${BVER}/config/
COPY --from=builder /node-binary/${NODETYPE}/prod/${BVER_PROD}/config/* /node-binary/fullnode/prod/${BVER}/config/
COPY --from=builder /node-binary/docker/bin/*.sh /usr/local/bin/

RUN set -ex \
&& chmod +x /usr/local/bin/*.sh \
&& mkdir -p "$BNCHOME" \
&& groupadd --gid "$HOST_USER_GID" bnbchaind \
&& useradd --uid "$HOST_USER_UID" --gid "$HOST_USER_GID" --shell /bin/bash --no-create-home bnbchaind \
&& chown -R bnbchaind:bnbchaind "$BNCHOME"

VOLUME ${BNCHOME}

# RPC service listen on port 27147 and P2P service listens on port 27146 by default.
# Prometheus is enabled on port 26660 by default, and the endpoint is /metrics.

EXPOSE 27146 27147 26660

ENTRYPOINT ["entrypoint.sh"]

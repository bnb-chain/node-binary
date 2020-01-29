FROM ubuntu:18.04 as builder

# Dockerfile for running Binance node from binary packages under docker
# https://docs.binance.org/fullnode.html#run-full-node-to-join-binance-chain
# MIT license
LABEL Maintainer = "Evgeny Varnavskiy <varnavruz@gmail.com>"
LABEL Description="Docker image for Binance full and light nodes"
LABEL License="MIT License"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates  git git-lfs binutils 
RUN	git lfs clone --depth 1 https://github.com/binance-chain/node-binary.git

# Final stage
FROM ubuntu:18.04
# UPDATE ME when new version is out !!!!
ARG BVER=0.6.3
ARG CLIVER=0.6.3

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000
ENV BVER=$BVER
ENV CLIVER=$CLIVER
ENV BNCHOME=/opt/bnbchaind

# Copy binaries for cli tool
COPY --from=builder /node-binary/cli/testnet/${CLIVER}/linux/tbnbcli /usr/local/bin/tbnbcli
COPY --from=builder /node-binary/cli/prod/${CLIVER}/linux/bnbcli /usr/local/bin/bnbcli

# Copy binaries for lightd and bnbchaind
COPY --from=builder /node-binary/lightnode/testnet/${BVER}/linux/lightd /usr/local/bin/lightd
COPY --from=builder /node-binary/fullnode/testnet/${BVER}/linux/bnbchaind /usr/local/bin/bnbchaind

# Copy config files for testnet and prod chains of fullnode
COPY --from=builder /node-binary/fullnode/testnet/${BVER}/config/* /node-binary/fullnode/testnet/${BVER}/config/
COPY --from=builder /node-binary/fullnode/prod/${BVER}/config/* /node-binary/fullnode/prod/${BVER}/config/

COPY ./bin/entrypoint.sh /usr/local/bin/

RUN set -ex \
&& chmod +x /usr/local/bin/* \
&& mkdir -p "$BNCHOME" \
&& groupadd --gid "$HOST_USER_GID" bnbchaind \
&& useradd --uid "$HOST_USER_UID" --gid "$HOST_USER_GID" --shell /bin/bash --no-create-home bnbchaind \
&& chown -R bnbchaind:bnbchaind "$BNCHOME"

VOLUME ${BNCHOME}

EXPOSE 80 27146 27147 26657 26660

ENTRYPOINT ["entrypoint.sh"]

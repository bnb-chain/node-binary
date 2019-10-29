# node-binary
Binaries for full nodes, light-weighted clients and user clients.

> Note: writeup below is in-progress by Daniel. Intent is to create a more beginner-friendly tutorial and writeup. Will add to `docs-site` subsequently

# Light Client

To run a Binance Chain node, you'll need to download a _client_ that you'll run on your local machine or server. Every node in the Binance Chain network runs the same _client_, which ensures that they know how to network and interface with each other.

Currently, Binance Chain distributes a compiled version of the _client_, which are called _binaries_. These can be found in the [`binance-chain/node-binaries` repo](https://github.com/binance-chain/node-binary).

## Installing Git LFS

The [`binance-chain/node-binaries` repo](https://github.com/binance-chain/node-binary) currently stores all versions of the node-binaries, and is a total download of >2GB.

Due to the size large size, we use [Git Large File Storage](https://git-lfs.github.com/) to only pull down the relevant version of the client when needed.

![](images/git-lfs-homepage.png)

### Step 1: Install [Git LFS](https://git-lfs.github.com/)

```shell
# Mac
brew install git-lfs
```

```
git lfs install
```


https://docs.binance.org/light-client.html

If you encounter the following error, there is some issue with your `Git LFS` installation.

```
~ line 1: version: command not found
~ line 2: oid: command not found
~ <directory>: 4432 No such file or directory
```

To solve this error, use

```
wget
```

https://github.com/binance-chain/node-binary/issues/122

# Full Node

https://docs.binance.org/fullnode.html
https://docs.binance.org/exchange-integration.html#running-a-full-node

# API Server

https://docs.binance.org/api-reference/api-server.html (running an API server on-machine)

-   [ ] What are the benefits of running an API server on-machine?

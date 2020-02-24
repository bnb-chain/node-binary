#!/bin/sh
# Install script for Binance Chain
#   - CLI (bnbcli)
#   - Full Node client (bnbchaind)
#   - Light Node client (lightd)
#   - Installs both testnet and prod

# Note: this is based on current structure of `node-binary` repo, which is not optimal
# - The installer script is a hack to simplify the installation process
# - Our binaries should eventually be refactor into a `apt` or `npm` repo, which features upgradability
# - We should not rely on folders for addressing (instead use git branches for versions)

# Detect operating system
# Future Improvement: Refactor into helper function
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  DETECTED_OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  DETECTED_OS="mac"
elif [[ "$OSTYPE" == "cygwin" ]]; then
  DETECTED_OS="linux"
elif [[ "$OSTYPE" == "msys" ]]; then
  DETECTED_OS="windows"
elif [[ "$OSTYPE" == "win32" ]]; then
  DETECTED_OS="windows" # TODO(Dan): can you run shell on windows?
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  DETECTED_OS="linux"
else
  FULLNODE_echo "Error: unable to detect operating system. Please install manually by referring to $DOCS_WEB_LINK"
  LIGHTNODE_DOCS_WEB_LINK=""
  exit 1
fi

# Check for existence of wget
if [ ! -x /usr/bin/wget ]; then
  # some extra check if wget is not installed at the usual place
  command -v wget >/dev/null 2>&1 || {
    echo >&2 "Error: you need to have wget installed and in your path. Use brew (mac) or apt (unix) to install wget"
    exit 1
  }
fi

echo "@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@         @@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@             @@@@@@@@@@@@@"
echo "@@@@@@@@@@@                 @@@@@@@@@@@"
echo "@@@@@@@@@         @@@         @@@@@@@@@"
echo "@@@@@@@@        @@@@@@@        @@@@@@@@"
echo "@@@@@@@@@@    @@@@@@@@@@@    @@@@@@@@@@"
echo "@@@   @@@@@@@@@@@@   @@@@@@@@@@@@   @@@"
echo "@       @@@@@@@@       @@@@@@@@       @"
echo "@       @@@@@@@@       @@@@@@@@       @"
echo "@@@   @@@@@@@@@@@@   @@@@@@@@@@@@   @@@"
echo "@@@@@@@@@@    @@@@@@@@@@@    @@@@@@@@@@"
echo "@@@@@@@@        @@@@@@@        @@@@@@@@"
echo "@@@@@@@@@         @@@         @@@@@@@@@"
echo "@@@@@@@@@@@                 @@@@@@@@@@@"
echo "@@@@@@@@@@@@@             @@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@         @@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@"
echo ""

echo "========== Binance Chain Node Installation =========="
echo "Installer Version: 0.1.beta"
echo "Detected OS: $DETECTED_OS"
echo "====================================================="

# Links to Documentation
FULLNODE_DOCS_WEB_LINK="https://docs.binance.org/fullnode.html"
LIGHTNODE_DOCS_WEB_LINK="https://docs.binance.org/light-client.html"

# Install location
USR_LOCAL_BIN="/usr/local/bin"
# Note: /usr/local/bin choice from https://unix.stackexchange.com/questions/259231/difference-between-usr-bin-and-usr-local-bin
# Future improvement: needs uninstall script (brew uninstall) that removes executable from bin

# Choose Full Node Directory
read -e -p "Choose home directory for Full Node [default: ~/.bnbchaind]:" BNC_FULLNODE_DIR
BNC_FULLNODE_DIR=${BNC_FULLNODE_DIR:-"$HOME/.bnbchaind"}

# Choose BNBCLI directory
read -e -p "Choose home directory for CLI [default: ~/.bnbcli]:" BNC_CLI_DIR
BNC_CLI_DIR=${BNC_CLI_DIR:-"$HOME/.bnbcli"}

# Choose Light Node directory
read -e -p "Choose home directory for Light Node [default: ~/.binance-lite]:" BNC_LIGHTNODE_DIR
BNC_LIGHTNODE_DIR=${BNC_LIGHTNODE_DIR:-"$HOME/.binance-lite"}

# Detect previous installation and create .bnbchaind folder,
BNC_FULLNODE_CONFIG_DIR="$BNC_FULLNODE_DIR/config"
echo "... creating $BNC_FULLNODE_DIR"
if [ -d "$BNC_FULLNODE_DIR" ]; then
  echo "... Error: Binance Chain Fullnode has already been installed"
  echo "... Error: Please remove contents of ${BNC_FULLNODE_DIR} before reinstalling."
  exit 1
else
  mkdir -p $BNC_FULLNODE_CONFIG_DIR
  cd $BNC_FULLNODE_DIR
fi
if [ -f "$USR_LOCAL_BIN/bnbchaind" ]; then
  echo "... Error: Binance Chain Fullnode has already been installed"
  echo "... Error: Please remove bnbchaind from /usr/local/bin before reinstalling."
  exit 1
fi
if [ -f "$USR_LOCAL_BIN/lightd" ]; then
  echo "... Error: Binance Chain Light Node has already been installed"
  echo "... Error: Please remove lightd from /usr/local/bin before reinstalling."
  exit 1
fi
if [ -f "$USR_LOCAL_BIN/bnbcli" ]; then
  echo "... Error: Binance Chain CLI Mainnet has already been installed"
  echo "... Error: Please remove bnbcli from /usr/local/bin before reinstalling."
  exit 1
fi
if [ -f "$USR_LOCAL_BIN/tbnbcli" ]; then
  echo "... Error: Binance Chain CLI Testnet has already been installed"
  echo "... Error: Please remove tbnbcli from /usr/local/bin before reinstalling."
  exit 1
fi

# Version selection options
# Future improvement: pull dynamically from version list

CLI_LATEST_VERSION="0.6.3"
# CLI_PROD_VERSION_NUMBERS=("0.5.8" "0.5.8.1" "0.6.0" "0.6.1" "0.6.2" "0.6.2-TSS-0.1.2" "0.6.3")
# CLI_TESTNET_VERSION_NUMBERS=("0.5.8" "0.5.8.1" "0.6.0" "0.6.1" "0.6.2" "0.6.2-TSS-0.1.2" "0.6.3")

FULLNODE_LATEST_VERSION="0.6.3-hotfix"
# FULLNODE_PROD_VERSION_NUMBERS=("0.5.8" "0.5.9" "0.5.10" "0.6.0" "0.6.1" "0.6.2" "0.6.3" "0.6.3-hotfix")
# FULLNODE_TESTNET_VERSION_NUMBERS=("0.5.8" "0.5.10" "0.6.0" "0.6.1" "0.6.1-hotfix" "0.6.2" "0.6.3" "0.6.3-hotfix")

LIGHTNODE_LATEST_VERSION="0.6.3"
# LIGHTNODE_PROD_VERSION_NUMBERS=("0.5.8" "0.6.0" "0.6.1" "0.6.2" "0.6.3")
# LIGHTNODE_TESTNET_VERSION_NUMBERS=("0.5.8" "0.6.0" "0.6.1" "0.6.2" "0.6.3")

# File Download URLs
GH_REPO_URL="https://github.com/binance-chain/node-binary/raw/master"

# Download both Testnet and Mainnet CLI
for NETWORK in "prod" "testnet"; do
  if [ "$NETWORK" = "prod" ]; then
    FILENAME="bnbcli"
  else
    FILENAME="tbnbcli"
  fi
  CLI_VERSION_PATH="cli/$NETWORK/$CLI_LATEST_VERSION/$DETECTED_OS/$FILENAME"
  CLI_BINARY_URL="$GH_REPO_URL/$CLI_VERSION_PATH"
  cd $USR_LOCAL_BIN
  echo "... Downloading $FILENAME executable version:" $CLI_LATEST_VERSION
  wget -q --show-progress "$CLI_BINARY_URL"
  chmod 755 "./$FILENAME"
done

# Download Light Node
LIGHTNODE_VERSION_PATH="lightnode/prod/$LIGHTNODE_LATEST_VERSION/$DETECTED_OS"
LIGHTNODE_BINARY_URL="$GH_REPO_URL/$LIGHTNODE_VERSION_PATH/lightd"

cd $USR_LOCAL_BIN
echo "... Downloading lightd executable version:" $LIGHTNODE_LATEST_VERSION
wget -q --show-progress "$LIGHTNODE_BINARY_URL"
chmod 755 "./lightd"

# Download Full Node
FULLNODE_VERSION_PATH="fullnode/prod/$FULLNODE_LATEST_VERSION"
FULLNODE_CONFIG_URL="$GH_REPO_URL/$FULLNODE_VERSION_PATH/config"
FULLNODE_BINARY_URL="$GH_REPO_URL/$FULLNODE_VERSION_PATH/$DETECTED_OS/bnbchaind"

cd $BNC_FULLNODE_CONFIG_DIR
echo "... Downloading config files for full node"
wget -q --show-progress "$FULLNODE_CONFIG_URL/app.toml"
wget -q --show-progress "$FULLNODE_CONFIG_URL/config.toml"
wget -q --show-progress "$FULLNODE_CONFIG_URL/genesis.json"

cd $USR_LOCAL_BIN
echo "... Downloading bnbchaind executable version:" $FULLNODE_LATEST_VERSION
wget -q --show-progress "$FULLNODE_BINARY_URL"
chmod 755 "./bnbchaind"

# exit 1

# Add installed version of Binance Chain to path
echo "... Installation successful!"
echo "... \`bnbcli\`, \`tbnbcli\`, \`bnbchaind\`, \`lightd\` added to $USR_LOCAL_BIN"

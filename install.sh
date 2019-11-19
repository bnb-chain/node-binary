#!/bin/sh
# Install script for Binance Chain
# Note: this is based on current structure of `node-binary` repo, which is not optimal
# Future improvement: version binaries using git, instead of folder structure

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

# Variables
read -e  -p "Hello, which directory is your home directory?" BNC_HOME_DIR
BNC_HOME_DIR=${BNC_HOME_DIR:-"$HOME/.bnbchaind"}
BNC_HOME_CONFIG_DIR=$BNC_HOME_DIR"/config"
FULLNODE_DOCS_WEB_LINK="https://docs.binance.org/fullnode.html"
LIGHTNODE_DOCS_WEB_LINK="https://docs.binance.org/light-client.html"
GH_REPO_URL="https://github.com/binance-chain/node-binary"
GH_RAW_PREFIX="raw/master"
GH_REPO_DL_URL="$GH_REPO_URL/$GH_RAW_PREFIX"

# Install location
# Note: /usr/local/bin choice from https://unix.stackexchange.com/questions/259231/difference-between-usr-bin-and-usr-local-bin
# Future improvement: needs uninstall script (brew uninstall) that removes executable from bin
USR_LOCAL_BIN="/usr/local/bin"
echo "... Choose Network Version"
OPTION_NETWORK=("Mainnet" "Testnet")
PS3='Choose Network Type: '
select opt in "${OPTION_NETWORK[@]}"; do
  case $opt in
  "Mainnet")
    NETWORK="prod"
    break
    ;;
  "Testnet")
    NETWORK="testnet"
    break
    ;;
  esac
done

# Version selection options
# Future improvement: pull dynamically from version list
OPTION_VERSION_NUMBER=("0.5.8" "0.5.9" "0.5.10" "0.6.0" "0.6.1" "0.6.2")
OPTION_NODE_TYPE=("Full Node" "Light Node")

echo "... Choose version of Binance Chain node to install"
PS3='Choose Version Number: '
select opt in "${OPTION_VERSION_NUMBER[@]}"; do
  VERSION_NUMBER="$opt"
  break
done

echo "... Choose node type to install"
PS3='Choose Node Type: '
select opt in "${OPTION_NODE_TYPE[@]}"; do
  case $opt in
  "Full Node")
    NODE_TYPE="fullnode"
    break
    ;;
  "Light Node")
    NODE_TYPE="lightnode"
    break
    ;;
  esac
done



# Download the selected binary
# Future improvement: versions should just be a single .zip payload (e.g. 0.6.2)
# Future improvement: should not use folder structure as addressing method
VERSION_PATH="$NODE_TYPE/$NETWORK/$VERSION_NUMBER"
GH_BASE_URL="$GH_REPO_URL/$GH_RAW_PREFIX/$VERSION_PATH"
CONFIG_DOWNLOAD_URL="$GH_BASE_URL/config"
NODE_BINARY_DOWNLOAD_URL="$GH_BASE_URL/$DETECTED_OS"

# wget the binary, config files
# Future improvement: should refactor in the future with releases in a single .zip or .tar.gz file
if [ $NODE_TYPE == "fullnode" ]; then

  # Detect previous installation and create .bnbchaind
  echo "... creating $BNC_HOME_DIR"
  if [ -d "$BNC_HOME_DIR" ]; then
    echo "... Error: Binance Chain Fullnode has already been installed"
    echo "... Error: Please remove contents of ${BNC_HOME_DIR} before reinstalling."
    exit 1
  else
    mkdir -p $BNC_HOME_CONFIG_DIR
    cd $BNC_HOME_DIR
  fi
  if [ -f "$USR_LOCAL_BIN/bnbchaind" ]; then
    echo "... Error: Binance Chain Fullnode has already been installed"
    echo "... Error: Please remove bnbchaind from /usr/local/bin before reinstalling."
    exit 1
  fi

  # Future improvement: should be refactored into helper function
  cd $USR_LOCAL_BIN
  echo "... Downloading bnbchaind executable"
  wget -q --show-progress "$NODE_BINARY_DOWNLOAD_URL/bnbchaind"
  chmod 755 "./bnbchaind"

  cd $BNC_HOME_CONFIG_DIR
  echo "... Downloading config files for version"
  wget -q --show-progress "$CONFIG_DOWNLOAD_URL/app.toml"
  wget -q --show-progress "$CONFIG_DOWNLOAD_URL/config.toml"
  wget -q --show-progress "$CONFIG_DOWNLOAD_URL/genesis.json"

  # Add installed version of Binance Chain to path
  echo "... Installation successful!"
  echo "... \`bnbchaind\` added to $USR_LOCAL_BIN"
  echo "... Visit full node documentation at $DOCS_WEB_LINK"
  echo "... Run \`bnbchaind\` to see list of available commands"

elif [ $NODE_TYPE == "lightnode" ]; then
  cd $USR_LOCAL_BIN
  echo "... Downloading lightd executable"
  wget -q --show-progress "$NODE_BINARY_DOWNLOAD_URL/lightd"
  chmod 755 "./lightd"

  echo "... Installation successful!"
  echo "... \`lightd\` added to $USR_LOCAL_BIN"
  echo "... Visit full node documentation at $DOCS_WEB_LINK"
  echo "... Run \`lightd\` to see list of available commands"
fi

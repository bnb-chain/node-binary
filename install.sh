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
  echo "Error: unable to detect operating system. Please install manually by referring to $DOCS_WEB_LINK"
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

echo "========== Binance Chain Node Installation =========="
echo "Version 0.1.beta"
echo "Detected OS: $DETECTED_OS"

# Variables
BNC_HOME_DIR="$HOME/.bnbchaind"
BNC_HOME_CONFIG_DIR="$HOME/.bnbchaind/config"
DOCS_WEB_LINK="https://docs.binance.org/fullnode.html"
GH_REPO_URL="https://github.com/binance-chain/node-binary"
GH_RAW_PREFIX="raw/master"
GH_REPO_DL_URL="$GH_REPO_URL/$GH_RAW_PREFIX"

# Version selection options
# Future improvement: pull dynamically from version list
OPTION_VERSION_NUMBER=("0.5.8" "0.5.9" "0.5.10" "0.6.0" "0.6.1" "0.6.2")
OPTION_NODE_TYPE=("Full Node" "Light Node")
OPTION_NETWORK=("Mainnet" "Testnet")

echo "...................................."
PS3='Choose Version Number: '
select opt in "${OPTION_VERSION_NUMBER[@]}"; do
  VERSION_NUMBER="$opt"
  break
done

echo "...................................."
PS3='Choose node type: '
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

echo "...................................."
PS3='Choose network type: '
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

# Download the selected binary
# Future improvement: versions should just be a single .zip payload (e.g. 0.6.2)
# Future improvement: should not use folder structure as addressing method
VERSION_PATH="$NODE_TYPE/$NETWORK/$VERSION_NUMBER"
GH_BASE_URL="$GH_REPO_URL/$GH_RAW_PREFIX/$VERSION_PATH"
CONFIG_DOWNLOAD_URL="$GH_BASE_URL/config"
NODE_BINARY_DOWNLOAD_URL="$GH_BASE_URL/$DETECTED_OS"

mkdir temp-bnbchain-installer
cd temp-bnbchain-installer

# wget the binary, config files
# Future improvement: should refactor in the future with releases in a single .zip or .tar.gz file
if [ $NODE_TYPE == "fullnode" ]; then
  # Future improvement: should be refactored into helper function

  # Create .bnbchaind in root
  echo "... creating $BNC_HOME_DIR"
  if [ -d "$BNC_HOME_DIR" ]; then
    echo "Error: Binance Chain client has already been installed. Please remove contents of ${BNC_HOME_DIR} before reinstalling."
    exit 1
  else
    mkdir -p $BNC_HOME_CONFIG_DIR
  fi

  wget "$CONFIG_DOWNLOAD_URL/app.toml"
  wget "$CONFIG_DOWNLOAD_URL/config.toml"
  wget "$CONFIG_DOWNLOAD_URL/genesis.json"
  wget "$NODE_BINARY_DOWNLOAD_URL/bnbchaind"

  # Copy config files over to ~/.bnbchaind
  echo "... copying version-specfic files to $BNC_HOME_DIR"
  for i in $(ls $pwd); do
    echo "    $i"
    cp "$pwd/$i" $BNC_HOME_CONFIG_DIR
  done
elif [ $NODE_TYPE == "lightnode" ]; then
  echo "$NODE_BINARY_DOWNLOAD_URL/lightd"
fi

# # Connect to seed
# # TODO(Dan): Find more elegant way to load variables from config.toml
# . "$SELECTED_BINARY_PATH/config.toml"
# echo "$seeds"

# # Add installed version of Binance Chain to path
echo "======= Installation complete ======="
echo "Please add bnbchaind to your path"
echo "  export PATH=\$PATH:/usr/local/.bnbchaind/bin"

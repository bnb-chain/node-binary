#!/bin/sh
# Install script for Binance Chain

# Intro
echo "========== Binance Chain Node Installation =========="
echo "Version 0.1.beta"

# Variables
BNC_HOME_DIR="$HOME/.bnbchaind"
BNC_HOME_CONFIG_DIR="$HOME/.bnbchaind/config"
DOCS_WEB_LINK="https://docs.binance.org/fullnode.html"

# Ask which version you want to install

# Create .bnbchaind in root
echo "... creating $BNC_HOME_DIR"
if [ -d "$BNC_HOME_DIR" ]; then
  echo "Error: Binance Chain client has already been installed. Please remove contents of ${BNC_HOME_DIR} before reinstalling." 
  exit 1
else
  mkdir -p $BNC_HOME_CONFIG_DIR
fi

# Ask which version to install
# TODO(Dan): Ask whether to install lightd or full node
# TODO(Dan): Get list of versions
# TODO(Dan): Ask whether to install testnet or prod
NODE_TYPE="fullnode"
VERSION_NUMBER="0.6.2"
NETWORK="prod"
SELECTED_BINARY_PATH="./$NODE_TYPE/$NETWORK/$VERSION_NUMBER/config"

# Copy config files over to ~/.bnbchaind
echo "... copying version-specfic files to $BNC_HOME_DIR"
for i in `ls $SELECTED_BINARY_PATH`
do
  echo "    $i"
  cp "$SELECTED_BINARY_PATH/$i" $BNC_HOME_CONFIG_DIR
done

# Detect operating system
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
  echo "Error: unable to detect operating system. Please install manually be referring to $DOCS_WEB_LINK"
  exit 1
fi

echo "$DETECTED_OS"

# Connect to seed
# TODO(Dan): Find more elegant way to load variables from config.toml
. "$SELECTED_BINARY_PATH/config.toml"
echo "$seeds"

# Add installed version of Binance Chain to path
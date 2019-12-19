#!/bin/bash

source setup.sh
echo "Running $0 in $PWD"
set -ev
su bnbchaind -c "/usr/local/bin/bnbchaind start --home ${BNCHOME}"

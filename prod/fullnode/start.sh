#!/bin/sh
systemctl daemon-reload
chkconfig bnbchaind on
chkconfig bnbcli on
service bnbchaind restart
service bnbcli restart
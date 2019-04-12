#!/bin/bash
#
export GOGC=200

function startChaind() {
    ip=`ifconfig eth0|grep inet|grep -v inet6 |awk '{ print $2 }'`
    sed -i -e "s/external_address = \"\"/external_address = \"${ip}:27146\"/g" /server/bnbchaind/fullnode/node/gaiad/config/config.toml
    sed -i -e "s?logFilePath = \".*\"?logFilePath = \"fullnode\/${ip}\/bnc.log\"?g" /server/bnbchaind/fullnode/node/gaiad/config/app.toml
    mkdir -p /mnt/efs/fullnode/${ip}
    /server/bnbchaind/fullnode/bnbchaind start --pruning breathe --home /server/bnbchaind/fullnode/node/gaiad --p2p.laddr  "tcp://0.0.0.0:27146" --rpc.laddr "tcp://0.0.0.0:27147" >> /mnt/efs/fullnode/${ip}/node.log 2>&1
}

function stopChaind() {
    pid=`ps -ef | grep /server/bnbchaind/fullnode/bnbchaind | grep -v grep | awk '{print $2}'`
    if [ -n "$pid" ]; then
        for((i=1;i<=4;i++));
        do
            kill $pid
            sleep 5
            pid=`ps -ef | grep /server/bnbchaind/fullnode/bnbchaind | grep -v grep | awk '{print $2}'`
            if [ -z "$pid" ]; then
                #echo "bnbchaind stoped"
                break
            elif [ $i -eq 4 ]; then
                kill -9 $kid
            fi
        done
    fi
}

CMD=$1

case $CMD in
-start)
    echo "start"
    startChaind
    ;;
-stop)
    echo "stop"
    stopChaind
    ;;
-restart)
    stopChaind
    sleep 3
    startChaind
    ;;
*)
    echo "Usage: chaind.sh -start | -stop | -restart .Or use systemctl start | stop | restart bnbchaind.service "
    ;;
esac

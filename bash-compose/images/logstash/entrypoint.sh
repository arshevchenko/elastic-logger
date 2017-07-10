#!/bin/sh
set -x

while [[ $(curl -s elasticsearch:9200/_cat/health | grep -qE "(green|yellow)"; echo $?) != 0 ]];
do
 sleep 1
done

for DATACENTER in $(ls -l | grep "^d" | awk '{print $9}'); do
    cd $DATACENTER/timestamped
    for timestamp in $(ls -l | grep "^d" | awk '{print $9}'); do
        cd $timestamp
        for NODE in $(ls -l | grep "^d" | awk '{print $9}'); do
            cd $NODE

            if test -d "kafka" ;
            then
                source /scripts/kafka.sh $DATACENTER $NODE
            fi
    

            if test -d "storm" ;
            then
                source /scripts/storm-errors.sh $DATACENTER $NODE
                source /scripts/storm-worker.sh $DATACENTER $NODE
            fi

        done
    done

    cd /opt/
done

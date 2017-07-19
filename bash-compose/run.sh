#!/bin/bash
source "./stop.sh"
docker run -d --name=elasticsearch \
           -v $2:/usr/share/elasticsearch/data \
           -p 9200:9200 -p 9300:9300 \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
              elasticsearch:5.4.0-alpine


docker build -t log_elk ./images/logstash/
docker run -d --name=logstash      \
           -v $1:/opt \
           -v $PWD/configs/properties.yml:/configs/properties.yml \
           -v $PWD/configs/logstash.yml:/usr/share/logstash/config/logstash.yml \
           -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
           --link elasticsearch            \
              log_elk


for port in $(seq 8081 8090); do
    if [[ ! $(netstat -tlp | grep -q ":$port") ]]
    then
        echo "Kibana will exposed at $port"
        KIBANA_PORT=$port
    break
    fi
done
   

docker run -d --name=kibana-ui \
           -p $KIBANA_PORT:5601   \
           --link elasticsearch \
              kibana:5.4.3 

echo "======================== WAIT ========================="
while [[ ! $(docker ps | grep -q "logstash") ]]
do
    echo "Logstash still working. Please wait for end of parsing."
    sleep 60
done

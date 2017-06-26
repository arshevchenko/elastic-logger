#!/bin/sh

#for NODE_NUM in $(seq 1 $NODES_NUM);
#do
#  NODE_NAME="p-niagara$(NODE_NAME)"

#  source kafka.sh $NODE_NAME 
#  source storm.sh $NODE_NAME
#  source zookeper.sh $NODE_NAME
#done

while [[ $(curl -s elasticsearch:9200/_cat/health | grep -qE "(green|yellow)"; echo $?) != 0 ]];
do
 sleep 1
done


set -x

for log in $(ls);
do
  LOG_NAME=${log/.*}
  FULL_PATH="$(pwd)/$log"

  cat > /usr/share/logstash/pipeline/${LOG_NAME}.conf << EOF 
input { 
  stdin{} 
} 

filter {
   grok {
     match => {
       "message" => "%{DATA:timest} \[%{DATA:interface}\] %{LOGLEVEL:log_level} %{GREEDYDATA:module} - %{GREEDYDATA:log_message}"
     }

     tag_on_failure => [ "Parsing error" ]
   }

   date {
     match => [ "timest", "HH:mm:ss.SSS"]
     target => "@timestamp"
   }

   mutate {
     remove_field => [ "timest", "message", "@version", "host" ]
   }
} 

output {
  stdout {
    codec => "rubydebug"
  }

  elasticsearch { 
    hosts => "elasticsearch:9200" 
    index => "$LOG_NAME"
  }
}
EOF

logstash -f /usr/share/logstash/pipeline/${LOG_NAME}.conf < $FULL_PATH

done

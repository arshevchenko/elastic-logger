#!/bin/sh

cat > /usr/share/logstash/pipeline/kafka-$1-$2.conf << EOF

input {
    stdin{}
}

filter {

    multiline {
        pattern => "^\["
        negate => true
        what => "previous"
    }

    grok {
        match =>{
            "message" => "\[%{DATA:times}\] %{LOGLEVEL:loglevel} %{GREEDYDATA:log_message}"
        }

        tag_on_failure => [ "Parsing error" ]
    }

    date {
        match => [ "times", "yyyy-MM-dd HH:mm:ss,SSS" ]
        target => "@timestamp"
    }

    mutate {

        add_field => {
            "datacenter" => "$1"
        }

        replace => {
            "host" => "$2"
            "message" => "%{log_message}" 
        }

        remove_field => [ "times", "log_message", "@version" ]

    }
}


output {
    stdout {
        codec => "rubydebug"
    }

    elasticsearch {
        hosts => "elasticsearch:9200"
        index => "kafka"
    }
}
EOF

logstash -f /usr/share/logstash/pipeline/kafka-$1-$2.conf < kafka/opt/server.log 


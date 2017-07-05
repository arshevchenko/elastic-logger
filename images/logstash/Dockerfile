FROM logstash:5.4.0-alpine

WORKDIR /opt
RUN apk add --no-cache curl grep
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-multiline

RUN mkdir /scripts

COPY ./scripts/ /scripts/
COPY ./entrypoint.sh /

RUN chmod -R +x /scripts
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

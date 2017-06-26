FROM logstash:5.4.0-alpine

WORKDIR /opt
RUN apk add --no-cache curl

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

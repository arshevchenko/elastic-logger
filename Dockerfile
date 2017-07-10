FROM docker:17.06-dind

RUN apk add --no-cache python py-pip
RUN pip install docker-compose 

WORKDIR /opt

RUN mkdir logs

VOLUME /opt/logs
EXPOSE 5601

COPY ./compose/ ./
RUN chmod +x -R .
 
ENTRYPOINT [ "docker-compose", "up" ]

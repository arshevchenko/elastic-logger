Integral-logger
===================
This docker-compose solution intended for log collection on specific project.


Usage
-----
**Automatically:**


**Manually:**

If you want to launch manually:

    docker build -t elk_integral .
    docker run -d -p PORT:5601 \ 
                  -v PATH_LOGS:/opt/logs/ \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                     elk_integral
                 


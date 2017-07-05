Integral-logger
===================
This docker-compose solution intended for log collection on specific project.


Usage
-----
**Automatically:**

Run **./run.sh** file with argument equal to your path to logs directory like this:

    ./run.sh ./logs
    
This script will automatically search free port for KIBANA. Ports are in range from 8080 to 8090. If port found, in terminal will displays message like this:

    Kibana will exposed at PORT_NUMBER

**Manually:**
If you want to launch manually, you must export this variables:

    export HOST_PATH="./path/to/logs/"
    export KIBANA_PORT="PORT"

After exporting, you can launch docker-compose.


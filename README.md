Integral-logger
===================
This docker-compose solution intended for log collection on specific project.


Usage
-----
**Automatically:**
All of this script in **./bash-compose** directory

Run **./run.sh** file with argument equal to your path to logs directory like this:

    ./run.sh ./logs
    
This script will automatically search free port for KIBANA. Ports are in range from 8080 to 8090. If port found, in terminal will displays message like this:

    Kibana will exposed at PORT_NUMBER

For stopping and removing containers use:
    
    ./stop.sh

For restarting containers use:

    ./restart.sh

For for viewing container state:

    ./ps.sh

Integral-logger
===================
This docker-compose solution intended for log collection on specific project.


Usage:
-----
**Automatically:**

Run **./run.sh** file with first argument equal to your path to logs directory and the second argument equal to path where would you like to store elasticsearch data:

    ./run.sh ./logs ./elastic-data
    
This script will automatically search free port for KIBANA. Ports are in range from 8080 to 8090. If port found, in terminal will displays message like this:

    Kibana will exposed at PORT_NUMBER

For stopping and removing containers use:
    
    ./stop.sh

For restarting containers use:

    ./restart.sh

For for viewing containers state:

    ./ps.sh

Configuration:
-----

For personal configuration you can use file **propeties.yml**. Here described all log files for parsing.

**Reference:**

|     Property    | Optional |  Type  | Description 
|-----------------|----------|--------|-----------------------------
| log\_file       | No       | regexp | Name of log file for parsing
| log\_type       | No       | string | Type of log file
| log\_stacktrace | Yes      | regexp | Pattern for stacktrace in log file
| grok\_pattern   | Yes      | string | Pattern for log string in grok
| time\_pattern   | Yes      | string | Pattern for time. Depends on variable **times** in grok
| add\_fields     | Yes      |  list  | List of additional fields for logstash
| replace\_fields | Yes      |  list  | List of fields for replace

Format of parameters in **add\_fields** and **replace_fields**:

| Parameter |       Type       | Description
|-----------|------------------|---------------------------------------------------------------------------------------------------------------------------
| type      |      string      | Has two types of values: string - basic string, in\_path - for searching value in path to log file with regular expression
| key       |      string      | The name of field in logstash
| value     | string or regexp | String for basic string and regexp for in\_path (see "type")

First launch:
-----

**Configuration:**

When you first launch this stack you must configurate search parameters. We don't have specific parameters for searching, because entrypoint of logstash image making all work. We will use \* instead logtash-\*. After them you must uncheck field with indexes and push the button at bottom of page.

**Search:**


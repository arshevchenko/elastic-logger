#!/usr/bin/env python

from os import walk, path, system, popen
from re import search

from yaml import load
from jinja2 import Environment, FileSystemLoader

def update_value(p, prop):
    for field in prop:
        if "in_path" in field["type"]:
          res = search(field["value"], p)
          if res is not None:
            g = 1 if "group" in field["type"] else 0
            field["value"] = res.group(g)


resp = popen("curl -s elasticsearch:9200/_cat/health").read()
while search("yellow|green", resp) is not None:
    resp = popen("curl -s elasticsearch:9200/_cat/health").read()
    print resp

properties = open("/configs/properties.yml", "r")
properties = load(properties)

env = Environment(
            loader=FileSystemLoader("/"), 
            trim_blocks=True
        )
template = env.get_template("templates/logstash.j2")



for root, dirs, files in walk("/opt"):
    for f in files:
        r = path.join(root, f)
        for p in properties:
            if search(p["log_file"], f) is not None:
                update_value(r, p["add_fields"])
                update_value(r, p["replace_fields"])
                render = template.render(log_stacktrace = p["log_stacktrace"],
                                grok_pattern = p["grok_pattern"],
                                time_pattern = p["time_pattern"],
                                add_fields = p["add_fields"],
                                replace_fields = p["replace_fields"],
                                log_type = p["log_type"])
                config = "/configs/{}.conf".format(p["log_type"])
                result = open(config, "w")
                result.write(render)
                result.close()

                system("logstash -f {} < {}".format(config, r))
                system("rm -rf {}".format(config))


                
                                 


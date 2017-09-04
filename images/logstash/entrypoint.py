#!/usr/bin/env python

from time import sleep
from subprocess import Popen, PIPE
from os import walk, path, system
from re import search

from yaml import load
from jinja2 import Environment, FileSystemLoader


def check_elastic():
    url = "elasticsearch:9200/_cat/health"
    response = Popen("curl -s {0}".format(url),
        stdout=PIPE, 
        stderr=PIPE,
        shell=True
    )
    out, err = response.communicate()
    return 'green' in out or 'yellow' in out
    
def update_value(p, prop):
    for field in prop:
        if "in_path" in field["type"]:
            res = search(field["value"], p)
            if res is not None:
                field["value"] = res.group(len(res.groups()))
            else:
                prop.remove(field)


if __name__ == "__main__":
    while check_elastic():
        print "Waiting for elaticsearch container..."
        sleep(20)

    properties = open("/configs/properties.yml", "r")
    properties = load(properties)
    env = Environment(
        loader=FileSystemLoader("/"),
        trim_blocks=True,
        lstrip_blocks=True
    )
    template = env.get_template("templates/logstash.j2")

    for root, dirs, files in walk("/opt"):
        for f in files:
            real_path = path.join(root, f)
            tmp_props = properties
            for prop in tmp_props:
                if search(prop["log_file"], f):
                    if "add_fields" in prop:
                        update_value(
                            real_path,
                            prop["add_fields"]
                        )
                    if "replace_fields" in prop:
                        update_value(
                            real_path,
                            prop["replace_fields"]
                        )
                    render = template.render(tmp=prop)
                    config = "/configs/{}.conf".format(prop["log_type"])
                    result = open(config, "w")
                    result.write(render)
                    result.close()
                    system("logstash -f {} < {}".format(
                        config,
                        real_path))
                    system("rm -rf {}".format(config))

#!/usr/bin/env python

import json
import sys
import os.path
import subprocess


def exec_commands(commands, exit=True):
    commands.insert(0, "set -x")
    commands.insert(0, "set -e")
    status = subprocess.call("\n".join(commands), shell=True)
    if exit and status != 0:
        sys.exit(status)


def clone_project(destdir, repository, url, id):
    print "\n###", repository
    repodir = '/'.join((destdir, repository))
    if not os.path.exists(repodir):
        src = os.getcwd()
        os.chdir(destdir)
        exec_commands(["git clone %s" % url])
        os.chdir(src)
    src = os.getcwd()
    os.chdir(repodir)
    exec_commands(["git checkout %s" % id], exit=False)
    os.chdir(src)


def main():
    destdir = sys.argv[1]
    with open('components.json', 'r') as fin:
        components_json = json.load(fin)

    repositories = components_json["repositories"]

    for name, descr in repositories.iteritems():
        url = descr["repository"]
        id = descr["id"]
        clone_project(destdir, name, url, id)


if __name__ == '__main__':
    main()


#!/usr/bin/env python

import json
import sys
import subprocess

PATH_DOCS = "result-docs/components"
PATH_REPOSITORIES = "repositories.work"

docs = {
    "epydoc": {
        "command": "epydoc -v --graph=all --docformat=restructuredtext "
                   "-o pythondoc .",
        "folder": "pythondoc"
    },
    "gradle": {
        "command": "gradle javadocJar",
        "folder": "build/docs/javadoc"
    },
    "doxygen": {
        "command": "doxygen Doxyfile",
        "folder": "html"
    }
}


def exec_commands(commands, exit=True):
    commands.insert(0, "set -x")
    commands.insert(0, "set -e")
    status = subprocess.call("\n".join(commands), shell=True)
    if exit and status != 0:
        sys.exit(status)


def create_folder(folder):
    commands = ["rm -rf %s" % folder,
                "mkdir -p %s" % folder]
    exec_commands(commands)


def remove_folder(folder):
    commands = ["rm -rf %s" % folder]
    exec_commands(commands)


def clone_project(repository, url, id):
    commands = ["cd %s" % PATH_REPOSITORIES,
                "git clone %s" % url,
                "cd %s" % repository,
                "git checkout %s" % id]
    exec_commands(commands, exit=False)


def generate_doc(path, doc):
    commands = ["cd %s/%s" % (PATH_REPOSITORIES, path),
                docs[doc]["command"]]
    exec_commands(commands)


def move_doc(component, path, doc):
    commands = ["mv %s/%s/%s %s/%s"
                % (PATH_REPOSITORIES, path, docs[doc]["folder"], PATH_DOCS,
                   component)]
    exec_commands(commands)


def main():
    with open('doc/components.json', 'r') as components_file:
        components_text = components_file.read()
    components_json = json.loads(components_text)
    repositories = components_json["repositories"]
    components = components_json["components"]

    create_folder(PATH_REPOSITORIES)
    for repository, value in repositories.iteritems():
        url = value["repository"]
        id = value["id"]
        clone_project(repository, url, id)

    create_folder(PATH_DOCS)
    for component, value in components.iteritems():
        repository = value["repository"]
        path = value.get("path", None)
        if path is None:
            path = repository
        else:
            path = repository + "/" + path
        doc = value.get("doc", None)
        if doc is not None:
            generate_doc(path, doc)
            move_doc(component, path, doc)

    remove_folder(PATH_REPOSITORIES)


if __name__ == '__main__':
    main()

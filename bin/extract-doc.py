#!/usr/bin/env python

import re, sys, argparse

parser = argparse.ArgumentParser(description="Fetch the components from git repositories")
parser.add_argument('--tag', default='DOC', type=str, help="Doc domain")
parser.add_argument('target', metavar='<PATH>', nargs='*', help="Path")
args = parser.parse_args()

pattern = '%s{{(.*?)}}%s' % (args.tag, args.tag)
extractor = re.compile(pattern, re.M|re.S|re.U)
for f in args.target:
    with open(f) as fin:
        buf = fin.read()
    for match in extractor.finditer(buf):
        for group in match.groups():
            print group


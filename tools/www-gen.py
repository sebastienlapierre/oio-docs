#!/usr/bin/env python

import sys
import os
import logging
import argparse

from bs4 import BeautifulSoup

import jinja2


def configure_logging(debug, verbose):
    logger = logging.getLogger(name='logger')
    formatter = logging.Formatter('%(asctime)s %(levelname)-8s %(message)s')
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    if verbose:
        logger.setLevel(logging.INFO)

    if debug:
        logger.setLevel(logging.DEBUG)

    return logging.getLogger('logger')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--debug", default=False,
                        action="store_true", help='Debug mode')
    parser.add_argument("--verbose", default=False,
                        action="store_true", help='Verbose mode')
    parser.add_argument("--input", type=str,
                        default='www', help='')
    parser.add_argument("--output", type=str,
                        default='result-docs/www', help='')

    args = parser.parse_args()
    logger = configure_logging(args.debug, args.verbose)

    try:
        loader = jinja2.FileSystemLoader(args.input)
        environment = jinja2.Environment(loader=loader)
    except Exception as e:
        logger.error("init template env failed: %s" % e)
        return 1

    for templateFile in environment.list_templates():
        if not templateFile.endswith('.html'):
            continue

        logger.info("gen %s" % templateFile)

        try:
            template = environment.get_template(templateFile)
        except Exception as e:
            logger.error("template %s parsing failed: %s" %
                         (templateFile, e))
            continue

        try:
            output = template.render()
            soup = BeautifulSoup(output, "lxml")
            output = soup.prettify()
        except Exception as e:
            logger.error("template %s rendering failed: %s" %
                         (templateFile, e))
            continue

        try:
            target_directory = os.path.join(args.output,
                                            os.path.dirname(templateFile))
            target_file = os.path.join(args.output, templateFile)
            if not os.path.isdir(target_directory):
                logger.debug("create target_directory %s" %
                             target_directory)
                os.makedirs(target_directory)
            logger.debug("write %s" % target_file)
            with open(os.path.join(target_file), 'wb') as f:
                f.write(output.encode('utf8'))
        except (IOError, OSError, UnicodeEncodeError) as e:
            logger.error("write %s failed: %s" % (target_file, e))
            continue

    return 0


if __name__ == '__main__':
    sys.exit(main())

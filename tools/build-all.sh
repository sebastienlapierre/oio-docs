#!/bin/bash -e

tools/build-all-rst.sh
python tools/www-gen.py --verbose --input www/ --output result-docs/
rsync -a www/static/ result-docs/

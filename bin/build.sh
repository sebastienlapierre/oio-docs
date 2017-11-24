#!/usr/bin/env bash
set -e
set -x

TARGET=result-docs
BUILD=$1
[[ -n "$BUILD" ]]

mkdir -p $TARGET

# Prepare an environment for the building process
mkdir -p "$BUILD"
./bin/gen-vars.py "$BUILD/vars.export"


# Generate the RAWX API
./bin/extract-doc.py --tag=RAWX \
  $(find $BUILD/oio-sds/rawx-apache2/src -type f -name '*.c' -or -name '*.h') \
  > doc/source/sdk-guide/rawx_api_calls.rst

./bin/extract-doc.py --tag=CS \
  $(find $BUILD/oio-sds/proxy -type f -name '*.c' -or -name '*.h') \
  > doc/source/sdk-guide/proxy_cs_api_calls.rst

./bin/extract-doc.py --tag=DIR \
  $(find $BUILD/oio-sds/proxy -type f -name '*.c' -or -name '*.h') \
  > doc/source/sdk-guide/proxy_dir_api_calls.rst

./bin/extract-doc.py --tag=CONTAINER \
  $(find $BUILD/oio-sds/proxy -type f -name '*.c' -or -name '*.h') \
  > doc/source/sdk-guide/proxy_container_api_calls.rst

./bin/extract-doc.py --tag=RDIR \
  $(find $BUILD/oio-sds/rdir -type f -name '*.c' -or -name '*.h') \
  > doc/source/sdk-guide/rdir_api_calls.rst

./bin/extract-doc.py --tag=ACCT \
  $(find $BUILD/oio-sds/oio/account -type f -name '*.py') \
  > doc/source/sdk-guide/acct_api_calls.rst


# Build the oio-sds variables
$BUILD/oio-sds/confgen.py rst "$BUILD/oio-sds/conf.json" \
  doc/source/admin-guide/variables.rst || true


if which doxygen 2>/dev/null >/dev/null ; then
  # Build the Java API javadoc
  if [[ -r doc/Doxyfile-api-java ]] ; then
    doxygen doc/Doxyfile-api-java > $BUILD/doxygen-java.out 2>&1
  fi

  # Build the C api doc
  if [[ -r doc/Doxyfile-api-c ]] ; then
    doxygen doc/Doxyfile-api-c > $BUILD/doxygen-c.out 2>&1
  fi
fi


# Build the python API doc
if [[ -d "$BUILD/oio-sds/oio" ]] ; then
  sphinx-apidoc -o doc/source/sdk-guide/python-api "$BUILD/oio-sds/oio"
fi


# We configured sphinx to make it document the python sdk. The modules will
# be loaded, we need even the dependencies.
( cd "$BUILD/oio-sds" \
  && pip install --upgrade -r test-requirements.txt \
  && pip install --upgrade -r all-requirements.txt \
  && python ./setup.py install )


# Patch the sources to expose the release of each component
SED='sed -i '
while read K V ; do
  SED="${SED}-e s,{{$K}},$V,g "
done < "${BUILD}/vars.export"
find doc/ -type f -name '*.rst' | while read P ; do
  $SED "$P"
done


# Gather all the parts
sphinx-build -v -E -d /tmp/sphinx doc $TARGET

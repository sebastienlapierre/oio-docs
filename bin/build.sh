#!/usr/bin/env bash
set -e
set -x
BUILD=build

# Prepare an environment for the building process
mkdir -p "$BUILD"
./bin/gen-vars.py "$BUILD/vars.export"
./bin/fetch-repositories.py $BUILD


# Build the oio-sds variables
$BUILD/oio-sds/confgen.py rst $BUILD/oio-sds/conf.json || true

# Build the Java API javadoc
if which gradle 2>/dev/null >/dev/null ; then
  if [[ -r "$BUILD/oio-api-java/gradlew" ]] ; then
    # Intentionally ignore the error
    ( set +e ; cd "$BUILD/oio-api-java" && gradle javadocJar ) || true
  fi
fi

if [[ -d "$BUILD/oio-api-java/build/docs/javadoc" ]] ; then
  cp -rp "$BUILD/oio-api-java/build/docs/javadoc" result-docs/java-api
fi


# Build the C api doc
if which doxygen 2>/dev/null >/dev/null ; then
  if [[ -r "$BUILD/oio-sds/core/Doxyfile" ]] ; then
    # Intentionally ignore the error
    ( "$BUILD/oio-sds/core" && doxygen ) || true
  fi
fi

if [[ -d "$BUILD/oio-sds/core/html" ]] ; then
  cp -rp "$BUILD/oio-sds/core/html" result-docs/c-api
fi


# Build the python API doc
if [[ -d "$BUILD/oio-sds/oio" ]] ; then
  sphinx-apidoc -o doc/source/sdk-guide/python-api "$BUILD/oio-sds/oio"
fi


# Gather all the parts
sphinx-build -E -d /tmp/sphinx doc result-docs

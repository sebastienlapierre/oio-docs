#!/usr/bin/env bash
set -e
set -x

BUILD=$1
[[ -n "$BUILD" ]]

# Prepare an environment for the building process
mkdir -p "$BUILD"
./bin/gen-vars.py "$BUILD/vars.export"


# Build the oio-sds variables
$BUILD/oio-sds/confgen.py rst $BUILD/oio-sds/conf.json \
  "$BUILD/doc/source/admin-guide/variables.rst" || true


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
    sed -i \
      -e 's/GENERATE_HTML.*/GENERATE_HTML = FALSE/' \
      -e 's/GENERATE_LATEX.*/GENERATE_LATEX = FALSE/' \
      -e 's/GENERATE_RTF.*/GENERATE_RTF = FALSE/' \
      -e 's/GENERATE_XML.*/GENERATE_XML = TRUE/' \
      "$BUILD/oio-sds/core/Doxyfile"
    # Intentionally ignore the error
    ( cd "$BUILD/oio-sds/core" && doxygen ) || true
    if [[ -d "$BUILD/oio-sds/core/xml" ]] ; then
      cp -rp "$BUILD/oio-sds/core/xml" "$BUILD/oio-sds-c-api"
    fi
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
sphinx-build -v -E -d /tmp/sphinx doc result-docs

========
Licenses
========

OpenIO releases its Open Source code under the term of variant of the GNU
Public License, a variant depending on the code.

* OpenIO sds_:

  * The LGPLv3 (GNU Lesser Public License, version 3) is used for all the code destined to be included in third-party applications. This is gathered under the core/ and metautils/ directories.
  * The AGPLv3 (GNU Affero Public License, version 3) is used elsewhere, and is always related to daemons or CLI tools.

* OpenIO Swift_: Apache License, Version 2
* OpenIO Java_ client: LGPLv3 (GNU Lesser Public License, version 3)
* OpenIO SDS, the puppet templates_: Apache License, Version 2

Compile-time dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~

Build our C codebase relies on:

* cmake_: 3-clause BSD
* GNU make_: GPL
* bison_: GPL (with a grant for generated code)
* gcc_: GPL
* flex_: BSD
* glib2_: LGPLv2
* libcurl_: MIT/X derivative License
* json-c_: 2-clauses BSD License
* asn1c_: 2-clauses BSD License

Building and testing our Java codebase depends on:

* gradle_: Apache License, Version 2
* junit_: Eclipse Public License, Version 1
* mockito_: MIT License
* jetty_: Apache License, Version 2

Delivery Dependencies
~~~~~~~~~~~~~~~~~~~~~

* vagrant_: MIT License
* virtualbox_: GPL
* puppet_: Apache License, Version 2


Runtime Dependencies
~~~~~~~~~~~~~~~~~~~~

The codebase written in C depends on:

* python_: BeOpen license
* httpd_ (and its shipped modules): Apache License, Version 2.0
* apr_: Apache License, Version 2.0
* libattr_: LGPLv2
* lzo_: GPLv2
* sqlite_: Public Domain (without support)
* zeromq3_: LGPLv2
* zookeeper_ (client): Apache License, Version 2.0
* liberasurecode_: BSD-style

The Java codebase depends on:

* log4j_: Apache License, Version 2
* gson_: Apache License, Version 2

OpenIO SDS also requires some side services to support it, all published under
the terms of a public license:

* gridinit_: AGPLv3
* beanstalkd_: MIT License
* zookeeper_ (server): Apache License, Version 2.0

Our runtime also requires the following python dependencies:

* python-setuptools_: MIT License
* python-pbr_: Apache License, Version 2
* python-eventlet_: MIT License
* python-werkzeug_: BSD License
* python-gunicorn_: MIT License
* python-plyvel_: BSD License
* python-redis_: MIT License
* python-requests_: Apache License, Version 2
* python-simplejson_: MIT License
* pyxattr_: MIT License
* python-cliff_: Apache License, Version 2
* python-pyeclib_: BSD License
* python-futures_: BSD License
* PyYAML_: MIT License

.. _pyyaml: https://pypi.python.org/pypi/PyYAML
.. _python-futures: https://pypi.python.org/pypi/futures
.. _pyxattr: https://pypi.python.org/pypi/xattr
.. _python-pyeclib: https://pypi.python.org/pypi/PyECLib
.. _python-cliff: https://pypi.python.org/pypi/simplejson
.. _python-simplejson: https://pypi.python.org/pypi/simplejson
.. _python-requests: https://pypi.python.org/pypi/requests
.. _python-redis: https://pypi.python.org/pypi/redis
.. _python-plyvel: https://pypi.python.org/pypi/plyvel
.. _python-gunicorn: https://pypi.python.org/pypi/gunicorn
.. _python-eventlet: https://pypi.python.org/pypi/eventlet
.. _python-werkzeug: https://pypi.python.org/pypi/Werkzeug
.. _python-setuptools: https://pypi.python.org/pypi/setuptools
.. _python-pbr: https://pypi.python.org/pypi/pbr
.. _sds: https://github.com/open-io/oio-sds
.. _Java: https://github.com/open-io/oio-api-java
.. _Swift: https://github.com/open-io/oio-swift
.. _templates: https://github.com/open-io/puppet-openiosds
.. _jetty: http://www.eclipse.org/jetty/
.. _mockito: https://github.com/mockito/mockito
.. _junit: http://junit.org/junit4/
.. _gradle: https://gradle.org/
.. _gson: https://github.com/google/gson
.. _log4j: https://logging.apache.org/log4j/2.x/
.. _puppet: https://puppet.com/
.. _virtualbox: https://www.virtualbox.org/
.. _vagrant: https://github.com/mitchellh/vagrant
.. _python: https://docs.python.org/3/license.html
.. _httpd: http://httpd.apache.org
.. _apr: http://apr.apache.org
.. _zookeeper: http://zookeeperapr.apache.org
.. _beanstalkd: https://github.com/kr/beanstalkd
.. _libattr: http://savannah.nongnu.org/projects/attr
.. _gridinit: https://github.com/open-io/gridinit
.. _lzo: http://www.oberhumer.com/opensource/lzo/
.. _sqlite: http://sqlite.org/
.. _make: https://www.gnu.org/software/make/
.. _cmake: https://cmake.org/
.. _bison: https://www.gnu.org/software/bison/
.. _flex: https://github.com/westes/flex
.. _gcc: https://gcc.gnu.org/
.. _glib2: https://developer.gnome.org/glib/
.. _zeromq3: http://zeromq.org/
.. _libcurl: https://curl.haxx.se/libcurl/
.. _json-c: https://github.com/json-c/json-c
.. _asn1c: https://github.com/open-io/asn1c
.. _liberasurecode: https://github.com/openstack/liberasurecode

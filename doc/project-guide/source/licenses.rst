========
Licenses
========

OpenIO releases its Open Source code under the term of variant of the GNU
Public License, a variant depending on the code.

* OpenIO sds:
  * The LGPLv3 (GNU Lesser Public License, version 3) is used for all the code
	destined to be included in third-party applications.
  * The AGPLv3 (GNU Affero Public License, version 3) is used for
	daemon-related code.
* OpenIO Swift: Apache License, Version 2
* OpenIO Java client: LGPLv3 (GNU Lesser Public License, version 3)
* OpenIO SDS, the puppet templates: Apache License, Version 2

Compile-time dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~

* cmake_: 3-clause BSD
* GNU make_: GPL
* bison_: GPL (with a grant for generated code)
* gcc_: GPL
* flex_: BSD
* glib2_: LGPLv2
* libcurl_: MIT/X derivative License
* json-c_: 2-clauses BSD License
* asn1c_ : 2-clauses BSD License


Delivery Dependencies
~~~~~~~~~~~~~~~~~~~~~

* vagrant_: MIT License
* virtualbox_: GPL
* puppet_: Apache License, Version 2


Runtime Dependencies
~~~~~~~~~~~~~~~~~~~~

* python_: BeOpen license
* httpd_ (and its shipped modules): Apache License, Version 2.0
* apr_: Apache License, Version 2.0
* libattr_: LGPLv2
* lzo_: GPLv2
* sqlite_: Public Domain (without support)
* zeromq3_: LGPLv2
* zookeeper_ (client): Apache License, Version 2.0
* liberasurecode_: BSD-style

OpenIO SDS also requires some side services to support it, all published under
the terms of a public license:

* gridinit_: AGPLv3
* beanstalkd_: you need it to have the event-agent working
* zookeeper_ (server): Apache License, Version 2.0

Our runtime also requires the following python dependencies:

* python-setuptools
* python-pbr
* python-eventlet
* python-werkzeug
* python-gunicorn
* python-plyvel
* python-redis
* python-requests
* python-simplejson
* pyxattr (python-xattr on Debian/Ubuntu)
* python-cliff
* python-pyeclib
* python-futures
* PyYAML

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

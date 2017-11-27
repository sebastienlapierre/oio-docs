====================================
Configure an Openstack Swift gateway
====================================

Description
~~~~~~~~~~~

The OpenIO flavor of the OpenStack Swift gateway that you are about to configure
is in facts a `WSGI <http://wsgi.org>`_ middleware placed in the pipeline,
before the vanilla swift service, to intercept and mangle the requests. If you
lack basic knowledge about Swift itself, please refer to the configuration guide
of `Openstack Swift <https://docs.openstack.org/kilo/config-reference/content/swift-general-service-configuration.html>`_.


Prerequisites
~~~~~~~~~~~~~

In this guide we suppose you have an OpenIO SDS namespace that is ready to use,
in version **{{OIO_SDS_BRANCHNAME}}**, and then an oio-swift gateway service in
version **{{OIO_SWIFT_BRANCHNAME}}**.

Its name is **OPENIO** and it is accessible through an `oio-proxy` at
**127.0.0.1:6000**.

If you do not have such an installation, please refer to the guide
":ref:`label-intall-guide`" for a production-grade installation, or to the
guide ":ref:`label-sandbox-guide`" for an installation "the hard way" (with
all the control you might dream of).


Common swift configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~

The goal of the present guide is not to detail how to configure OpenStack Swift.
For more informatio feel free to read the document of the swift version you are
deploying. We'll present only the directives you cannot avoid.

bind_ip
-------

Restrict the address used to listen for incoming connections.
The address must be mounted on a local interface.

* Format: dot-decimal representation of an IPv4 address or a colon-hexadecimal representation of an IPv6 address
* Default: `0.0.0.0`
* Context: `DEFAULT` << `app:*`

.. code-block:: ini
   :caption: example

   bind_ip = 127.0.0.1


bind_port
---------

Specifies the TCP port to bind to, and listen to incoming connections.
Obviously, in order to run the oio-swift server bound to this port, no other
process must be bound on it.
Please refer to the documentation of your operating system for the restrictions
on some ranges of ports that could require *ad hoc* authorizing.

* Format: positive integer less than 65535
* Default: None
* Context: `DEFAULT` << `app:*`

.. code-block:: ini
   :caption: example

   bind_port = 5999


workers
-------

Describes the number of children processes. These children workers manage the
incoming requests while the master process monitor its worker children.
When a child dies, it is spawned again.

* Format: positive integer
* Default: 1
* Context: `DEFAULT`

.. code-block:: ini
   :caption: example

   workers = 10


user
----

If oio-swift is started as **root**, you can specify a user name or ID
to `setuid()`.

* Format: a declared user name or a positive integer
* Default: None
* Context: `DEFAULT`

.. code-block:: ini
   :caption: example

   user = nobody


log_facility
------------

Tells which **syslog** facility has to be used for both the access log and the error log.
Please refer to the syslog man page for more information.

* Format: a valid syslog facility name.
* Default: **LOG_LOCAL0**
* Context: `DEFAULT`

.. code-block:: ini
   :caption: example

   log_facility = LOG_LOCAL0


log_address
-----------

Tells where the logs (access and error) should be sent to.

* Format: a TCP/IP address or the path to a AF_LOCAL socket
* Default: **/dev/log**
* Context: `DEFAULT`

.. TODO AF_LOCAL .. . SOCK_STREAM or SOCK_DGRAM (connected or not) ?

.. code-block:: ini
   :caption: example

   log_address = /dev/log


log_name
--------

Tells which syslog ID has to be used for both the access log and the error log.
This tag is part of the syslog protocol and is present on each line.

* Format: a printable string with space
* Default: None
* Context: `DEFAULT`

.. code-block:: ini
   :caption: example

   log_name = OIO,DAILYMOTION,oioswift,1


eventlet_debug
--------------

Turn `eventlet_debug` to `true` to make the python package `eventlet` output
more traces about its internal activity.

.. code-block:: ini
   :caption: example

   eventlet_debug = false


Specific oio-swift configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sds_namespace
-------------

.. code-block:: ini
   :caption: example

   sds_namespace = OPENIO


sds_proxy_url
-------------

.. code-block:: ini
   :caption: example

   sds_proxy_url = http://127.0.0.1:6000


sds_default_account
-------------------

.. code-block:: ini
   :caption: example

   sds_default_account = ACCT


sds_connection_timeout
----------------------

.. code-block:: ini
   :caption: example

   sds_connection_timeout = 5


sds_read_timeout
----------------

.. code-block:: ini
   :caption: example

   sds_read_timeout = 35


sds_write_timeout
-----------------

.. code-block:: ini
   :caption: example

   sds_write_timeout = 35


sds_pool_connections
--------------------

.. code-block:: ini
   :caption: example

   sds_pool_connections = 500


sds_pool_maxsize
----------------

.. code-block:: ini
   :caption: example

   sds_pool_maxsize = 500


sds_max_retries
---------------

.. code-block:: ini
   :caption: example

   sds_max_retries = 1


oio_storage_policies
--------------------

.. code-block:: ini
   :caption: example

   oio_storage_policies=SINGLE,THREECOPIES,EC


auto_storage_policies
---------------------

.. code-block:: ini
   :caption: example

   auto_storage_policies=EC,THREECOPIES:1,EC:262144


pipeline
--------

.. note:: context

   pipeline


.. code-block:: ini
   :caption: example

   pipeline = catch_errors hashedcontainer gatekeeper healthcheck proxy-logging cache bulk tempurl ratelimit  container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server


allow_account_management
------------------------

.. code-block:: ini
   :caption: example

   allow_account_management = true


account_autocreate
------------------

.. code-block:: ini
   :caption: example

   account_autocreate = true


Configuration: [filter:copy]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini
   :caption: example

   use = egg:swift#copy
   object_post_as_copy = false
 
Configuration: [filter:hashedcontainer]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini
   :caption: example

   use = egg:oioswift#hashedcontainer

Additional notes
~~~~~~~~~~~~~~~~

Please find here a sample configuration:

.. code-block:: ini
   :caption: Complete example

   [DEFAULT]
   bind_port = 5999
   workers = 10
   user = jfs
   log_facility = /dev/log
   eventlet_debug = false
   sds_namespace = OPENIO
   sds_proxy_url = http://127.0.0.1:6000
   sds_default_account = ACCT
   sds_connection_timeout = 5
   sds_read_timeout = 35
   sds_write_timeout = 35
   sds_pool_connections = 500
   sds_pool_maxsize = 500
   sds_max_retries = 1
   oio_storage_policies=SINGLE,THREECOPIES,EC
   auto_storage_policies=EC,THREECOPIES:1,EC:262144

   [pipeline:main]
   #pipeline = catch_errors hashedcontainer gatekeeper healthcheck proxy-logging cache bulk tempurl ratelimit  container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server
   pipeline = catch_errors gatekeeper healthcheck proxy-logging cache bulk tempurl ratelimit  container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server

   [app:proxy-server]
   use = egg:oioswift#main
   bind_ip = 0.0.0.0
   object_post_as_copy = false
   allow_account_management = true
   account_autocreate = true
   log_name = OIO,DAILYMOTION,oioswift,1
   [filter:bulk]
   use = egg:swift#bulk
   [filter:slo]
   use = egg:swift#slo
   [filter:dlo]
   use = egg:swift#dlo
   [filter:staticweb]
   use = egg:swift#staticweb
   [filter:account-quotas]
   use = egg:swift#account_quotas
   [filter:container-quotas]
   use = egg:swift#container_quotas
   [filter:versioned_writes]
   use = egg:swift#versioned_writes
   allow_versioned_writes = true
   [filter:crossdomain]
   use = egg:swift#crossdomain
   [filter:gatekeeper]
   use = egg:swift#gatekeeper
   [filter:proxy-logging]
   use = egg:swift#proxy_logging
   access_log_headers = false
   access_log_headers_only =
   [filter:tempurl]
   use = egg:swift#tempurl
   [filter:catch_errors]
   use = egg:swift#catch_errors
   [filter:ratelimit]
   use = egg:swift#ratelimit
   [filter:healthcheck]
   use = egg:swift#healthcheck
   [filter:cache]
   use = egg:swift#memcache
   memcache_servers = 10.195.3.24:6019
   memcache_max_connections = 500
   [filter:copy]
   use = egg:swift#copy
   object_post_as_copy = false
   [filter:hashedcontainer]
   use = egg:oioswift#hashedcontainer



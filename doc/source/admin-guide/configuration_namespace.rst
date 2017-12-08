.. _ref-admin-guide:

=====================================
Tweak the variables of your namespace
=====================================

Service locations
~~~~~~~~~~~~~~~~~

proxy
-----

Tells the client SDK where is the `oio-proxy` to be used, as the primary
endpoint to the namespace.

.. code-block:: text

    proxy=IP:PORT


conscience
----------

Tells the `oio-proxy` (and only the proxy) where is the `conscience` central
service to be used.

.. code-block:: text

    conscience=IP:PORT[,IP:PORT]*


zookeeper
---------

Tells all the sqlitrepo-based service to connection string to be used to connect
the Zookeeper cluster. Are concerned the meta0, meta1, meta2 and sqlx services.

.. code-block:: text

    zookeeper=IP:PORT[,IP:PORT]*


zookeeper.$SRVTYPE
------------------

Under certain circumstances, it is necessary to insulte the elections of a
particuler service type into its own Zookeeper. E.g. because it is too critical
or space consuming. The `zookeeper.$SRVTYPE` is dedicated to override the global
`zookeeper` configuration.

.. code-block:: text

    zookeeper.meta0=IP:PORT
    zookeeper.meta1=IP:PORT
    zookeeper.meta2=IP:PORT
    zookeeper.sqlx=IP:PORT

proxy-local
-----------

When it is necessary to make the C SDK use local sockets to the local proxy,
this is the parameter to be configured.

.. code-block:: text

    proxy-local=/path/to/proxy.sock


ecd
---

Tells the client SDK where is the `erasure code daemon` that will manage the
complex task of computing the erasure code on the data.

.. code-block:: text

    ecd=IP:PORT


event-agent
-----------

That directove tells the services the protocol and the endpoint to deposit
notifications. Two implementations are currently available: the default solution
is `beanstalkd` (and is identified by `beanstalkd://` endpoints), and the other
is a ZeroMQ Request/Reply service (identified by `ipc://` and `tcp://`
endpoints).

.. code-block:: text

    # Configuration usiing beanstalkd
    event-agent=beanstalk://IP:PORT

    # Configuration using ZeroMQ
    event-agent=ipc:///path/to/event-agent.sock
    event-agent=tcp://IP:PORT


meta1_digits
------------

Please refer to the section about the sizing considerations.

Set to 4 as a default.

.. code-block:: text

    meta1_digits=0|1|2|3|4


.. include:: variables.rst

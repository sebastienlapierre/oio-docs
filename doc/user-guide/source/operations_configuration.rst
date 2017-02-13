========================
OpenIO SDS configuration
========================

Options

Namespace-wide global configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Variables spread in via the conscience.

chunk_size
----------

Tells the services how to split the data of each content before spreaing the
chunks on RAWX services.

.. code-block:: ini

    param_chunk_size=${UINT64}


option.state
------------

Set to `standalone` by default, the state tells which commands are accepted by
oio-sds. A namespace in `standalone` mode

.. code-block:: ini

    param_option.state=standalone|master|slave


option.worm
-----------

WORM stands for *Write Once, Read Many (and delete never)* and is intended for
backup namespaces on situations of asynchronous replication. False by default,
when activated it forbids direct removal of any content, by regular clients.

.. code-block:: ini

    param_option.worm=yes|true|on|no|false|off


option.events-max-pending
-------------------------

.. code-block:: ini

    param_option.events-max-pending: 10000


option.$SRVTYPE.events-max-pending
----------------------------------

.. code-block:: ini

    param_option.sqlx.events-max-pending=1000
    param_option.meta2.events-max-pending=1000
    param_option.meta1.events-max-pending=100


option.events-buffer-delay
--------------------------

.. code-block:: ini

    param_option.meta1.events-buffer-delay=5
    param_option.meta2.events-buffer-delay=5
    param_option.sqlx.events-buffer-delay=5


option.$SRVTYPE.events-buffer-delay
-----------------------------------

.. code-block:: ini

    param_option.meta1.events-buffer-delay=5
    param_option.meta2.events-buffer-delay=5
    param_option.sqlx.events-buffer-delay=5


option.service_update_policy
----------------------------

.. code-block:: ini

    param_option.service_update_policy=($SRVTYPE=(KEEP|APPEND|REPLACE)|$COUNT|$DISTANCE[|user_is_a_service=$SRVTYPE])+


option.meta2_max_versions
-------------------------

.. code-block:: ini

    param_option.meta2_max_versions=-1|0|$UINT64


option.meta2_keep_deleted_delay
-------------------------------

.. code-block:: ini

    param_option.meta2_keep_deleted_delay=$SECONDS


option.container_max_size
-------------------------

.. code-block:: ini

    param_option.container_max_size=$BYTES


option.flat_bitlength
---------------------

.. code-block:: ini

    param_option.flatbitlength=16


option.storage_policy
---------------------

No default value, at least `SINGLE` is alway recognized as a single copy that
will target `rawx` services.

.. code-block:: ini

    option.storage_policy=$POLICY_NAME


Obsolete namespace-wide / global options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

    option.flat_hash_offset=$UINT
    option.flat_hash_size=$UINT
    option.compression=$BOOL


Namespace-wide local configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Variables present in namespace sections of the local configuration, read by all
the services of that namespace.


proxy
-----

Tells the client SDK where is the `oio-proxy` to be used, as the primary
endpoint to the namespace.

.. code-block:: ini

    proxy=IP:PORT


conscience
----------

Tells the `oio-proxy` (and only the proxy) where is the `conscience` central
service to be used.

.. code-block:: ini

    conscience=IP:PORT[,IP:PORT]*


zookeeper
---------

Tells all the sqlitrepo-based service to connection string to be used to connect
the Zookeeper cluster. Are concerned the meta0, meta1, meta2 and sqlx services.

.. code-block:: ini

    zookeeper=IP:PORT[,IP:PORT]*


zookeeper.$SRVTYPE
------------------

Under certain circumstances, it is necessary to insulte the elections of a
particuler service type into its own Zookeeper. E.g. because it is too critical
or space consuming. The `zookeeper.$SRVTYPE` is dedicated to override the global
`zookeeper` configuration.

.. code-block:: ini

    zookeeper.meta0=IP:PORT
    zookeeper.meta1=IP:PORT
    zookeeper.meta2=IP:PORT
    zookeeper.sqlx=IP:PORT

proxy-local
-----------

When it is necessary to make the C SDK use local sockets to the local proxy,
this is the parameter to be configured.

.. code-block:: ini

    proxy-local=/path/to/proxy.sock


ecd
---

Tells the client SDK where is the `erasure code daemon` that will manage the
complex task of computing the erasure code on the data.

.. code-block:: ini

    ecd=IP:PORT


event-agent
-----------

That directove tells the services the protocol and the endpoint to deposit
notifications. Two implementations are currently available: the default solution
is `beanstalkd` (and is identified by `beanstalkd://` endpoints), and the other
is a ZeroMQ Request/Reply service (identified by `ipc://` and `tcp://`
endpoints).

.. code-block:: ini

    # Configuration usiing beanstalkd
    event-agent=beanstalk://IP:PORT

    # Configuration using ZeroMQ
    event-agent=ipc:///path/to/event-agent.sock
    event-agent=tcp://IP:PORT

log_outgoing
------------

Set to `false` by default. When it is actived the services generated an outgoing
access log, for both UDP and TCP messages. Be careful, The generated log can
grow rapidly!

.. code-block:: ini

    log_outgoing=yes|true|on|no|false|off

avoid_faulty_services
---------------------

Turned off by default, this option is only considered by the `proxy`, `meta2`,
`meta1` and `sqlx` services. Turning it on actives a short-term memory of the
network errors that occured when contacting `gridd` services. When the number of
errors during the reference period.

.. code-block:: ini

    avoid_faulty_services=yes|true|on|no|false|off

udp_allowed
-----------

Should the services on the local host use UDP for the **DB_USE** requests
involved in *sqliterepo* elections? Whether you turn it on or off, any service
is able to understand UDP request, and will serve them.
Using UDP on the client side will hide connection errors but save a lot of
frames on the wire, save memory allocation (due to pending DB_USE requests that
don't need to be queued), and save file descriptors.

.. code-block:: ini

    udp_allowed=yes|true|on|no|false|off

meta1_digits
------------

Please refer to the section about the sizing considerations.

Set to 4 as a default.

.. code-block:: ini

    meta1_digits=0|1|2|3|4

zk_shuffled
-----------

Don't use this option, it will be removed soon. It is turned down by default.

.. code-block:: ini

    zk_shuffled=yes|true|on|no|false|off


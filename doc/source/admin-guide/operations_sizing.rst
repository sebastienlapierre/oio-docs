=====================
Sizing considerations
=====================

meta0/meta1: size the top-level index
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In OpenIO SDS, the directory of services acts like a hash table: an associative
array mapping unique identifiers to list of services. Each unique ID corresponds
to an end-user of the platform.

Our directory of services uses separate chaining to manage the collisions: each
slot of the top-level index point to a SQLite database managing all the services
with the same hash. The top-level hash is managed by the `meta0` service, while
each slot is a base managed by `meta1` services.

So, how properly to dimension the top-level index in `meta0`? In other words,
how many `meta1` shards do you require? It will depend on the number of items
you plan to have in each `meta1` base, and there is one item for each services
linked to an end-user.

.. note::
  We recommend to stay below 100k entries per SQLite file as a maximum, and
  below 10k entries as a good practice.

.. list-table:: Meta1 sharding
   :header-rows: 1
   :widths: 5 5 75

   * - Digits
     - Slots
     - Behaviour
   * - 4
     - 65536
     - good for huge deployments (> 100M linked services)
   * - 3
     - 4096
     - good until 100M linked services
   * - 2
     - 256
     - Adviced when less then 64k, e.g. for "flat namespaces"
   * - 1
     - 16
     - minimal hash, only for demonstration purposes and sandboxing.
   * - 0
     - 1
     - no-op hash, only for demonstration purposes.


sqliterepo: how many services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`sqliterepo` is the piece of software managing a repository of SQLite databases,
a cache of open databases and a lock around each database usage. This piece of
software is used is the `meta0`, `meta1`, `meta2` and `sqlx` services.

While the total number of databases currently held by the repository is not
limited, the number of active bases should be low enough to be kept by the
current cache size.

As a default, that maximum number of bases kept in cache is deduced to **1/3**
from the maximum number of open files allowed to the server, a.k.a. the
**RLIMIT_NOFILE** fields of the `getrlimit()`, a.k.a. the value `ulimit -n` will
tell you.

.. note::
  For a given type of service based on `sqliterepo`, you should deploy enough
  services to have the active part of you population [of data] kept open and
  cached.


Zookeeper configuration (cluster)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With small demonstration or sandbox deployments, you won't need to precisely
dimension your Zookeeper instance.

https://zookeeper.apache.org/doc/trunk/zookeeperAdmin.html

Garbage collection
------------------

Make the Zookeeper doesn't hang for too long while collecting the garbage memory
and use the best GC implementation possible.

.. note::
   -XX:+UseParallelGC -XX:ParallelGCThreads=8

jute.maxbuffer
--------------

When the Zookeeper client is connected to the Zookeeper cluster, it sends
heartbeat messages that refresh all the ephemeral nodes metadata, thus extending
their TTL. The information will be transactionally replicated to all the nodes
in the cluster, and the transaction to do so will include the connection of the
client. The **jute.maxbuffer** is the maximum size allowed for the buffer in
such an intra-cluster replication.

The problem we encounter is that the transaction includes the client's
connection, so that if the transaction fails, the connection of the client will
be reset by the cluster's node. But the FSM (internal to the client) won't enter
in the **DISCONNECTED** state and the application won't be able to react on that
situation. And an insufficient buffer size is a well-known cause for a
transaction to fail. The symptom will be a client app. continuously reconnecting
to the Zookeeper cluster, with the service consuming 100% CPU (in the ZK
background thread).

The value is configured as a system property, on the Zookeeper CLI with the help
of a ``-Djute.maxbuffer=...`` option.

.. note::
   In the usage of Zookeeper made by OpenIO SDS, we roughly estimate that each
   ephemeral node might require 150 bytes of metadata (110 for its name, 20 for
   the metadata, and 20 for the codec itself).

   The default value for the buffer size is set to 1048576, and lets you manage
   ~7900 ephemeral nodes, so ~7900 active bases on the server.

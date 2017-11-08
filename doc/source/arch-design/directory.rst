====================================
Directory of services (meta0, meta1)
====================================

OpenIO heavily relies on the Service Directory, its main function is
locating a specific Service for a given Reference.

References
----------
References are named groups of service links.
Internally, their name is hashed to a 64 bytes hexadecimal string.
References are managed by the second level of the service directory (Meta1).

Prefixes
--------
Prefixes are the first bytes of hashed reference names. They are used
to shard the references on the first level of the service directory (Meta0).
In the current implementation, prefixes are 16 bits long, so there is exactly
65536 of them.

Linking
-------
Once a reference is created, you can link a set of Services to it.
This used for example for Object Storage Container Services.

Directory Replication
---------------------

Each prefix has its own replication cluster. The replication cluster is created and
the participating directory servers are selected when the prefix is created.
Each replication cluster has a single master and a set of slaves, the master manages
write operations and replicates them to its slaves.
A write operation is considered successful when the replication quorum is respected.
Note that slaves can also perform reads if requested.

Transient failures like network partitions can cause replicas to diverge, with this
replication mechanism differences are reconciled automatically.

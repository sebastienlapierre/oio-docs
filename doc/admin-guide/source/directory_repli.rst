===========
Replication
===========

Directory Replication
~~~~~~~~~~~~~~~~~~~~~

Each prefix has its own replication cluster. The replication cluster is created and
the participating directory servers are selected when the prefix is created.
Each replication cluster has a single master and a set of slaves, the master manages
write operations and replicates them to its slaves.
A write operation is considered successful when the replication quorum is respected.
Note that slaves can also perform reads if requested.

Transient failures like network partitions can cause replicas to diverge, with this
replication mechanism differences are reconciled automatically.

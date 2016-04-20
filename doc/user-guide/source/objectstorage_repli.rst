===========
Replication
===========

Container Replication
~~~~~~~~~~~~~~~~~~~~~

Container replication is performed using the same mechanism as the Service Directory replication.
Each container has its own replication cluster.
The participating container servers are selected when the container is created.
This selection is done respecting specific service distance constraints.

Object Replication
~~~~~~~~~~~~~~~~~~

Object replication is performed at the chunk level.
At the time of object upload, chunks are uploaded by the client on the chunk servers in parallel. If one of the chunk servers fails during this operation, the object upload can continue while the replication quorum is respected.

Missing replicas are repaired in the background using the Auditor.

========
Features
========

Hardware Agnostic
~~~~~~~~~~~~~~~~~

OpenIO SDS can be used with nodes of different performance while at the same time keeping
everything load balanced so that you get the most out of your hardware.

Replication
~~~~~~~~~~~

Metadata and data are secured using replication, so that a storage node failure
does not result in data loss.

Storage Tiering
~~~~~~~~~~~~~~~

Create and configure Storage Policies to change how and where objects are stored,
for example to differentiate the kind of storage device used (SSD vs HDD).
A storage container is configured with a specific Storage Policy, depending on your needs.
You can then move an object from one Storage Policy to another, for example depending on
its age.
In a namespace, you may have several Storage Policies defined.

Isolation
~~~~~~~~~

OpenIO SDS provides isolation for its containers, each container consists in a single
database file.

Integrity
~~~~~~~~~

Integrity checks are performed periodically to ensure that no silent data corruption or
loss occurs.

Erasure Coding
~~~~~~~~~~~~~~

With erasure coding you can store objects durably with a much lower overhead than
standard replication.

Versioning
~~~~~~~~~~

A container has the ability to track several versions of the same object. Using object
versioning, you can list and restore previous versions of an object.

Compression
~~~~~~~~~~~

Compression can be performed on chunks, this can greatly helps with you storage cost.
Note that due to compression algorithms used the storage savings you can expect really
depends on the kind of objects that are stored.
For example: it is usually good for emails, but not so much for videos.

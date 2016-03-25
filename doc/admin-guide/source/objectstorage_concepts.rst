========
Concepts
========

- ** Accounts ** -
- ** Containers ** -
- ** Objects ** -

Accounts
--------

List of containers in that account.
An account server uses redis cluster as a metadata storage backend.

Containers
----------

Containers keep track of object data locations.
Each container is an individual SQLite database that is distributed
accross the cluster. Containers are replicated.

Objects
-------

Objects are made of chunks.

Objects are chunked depending Chunk Size a value defined in the namespace configuration.



Container Lookup
~~~~~~~~~~~~~~~~

account/container/object

Use the Service Directory API to find the container servers managing the given container.

Container Create
~~~~~~~~~~~~~~~~

Create a reference using the Service Directory API (if it does not already exists)

Locate available container servers using the Conscience API
respecting the placement constraints etc. link them to the reference
A master is automatically elected and a new container is created

Container List
~~~~~~~~~~~~~~

List the container, listing options: limit, prefix, marker etc
useful for large lists.

Container Destroy
~~~~~~~~~~~~~~~~~

Destroy the container


Object Upload
~~~~~~~~~~~~~

Use the conscience to find storage nodes

Asynchronous tasks


Object Download
~~~~~~~~~~~~~~~

Fetch the chunks position
Download the content depending on the range asked
Also uses the current conscience infos to select the best nodes.

Object Delete
~~~~~~~~~~~~~

Delete the object entry (respecting versioning rules)

Asynchronous tasks

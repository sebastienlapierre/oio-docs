============
Architecture
============

OpenIO designed its object storage as the composition of core services. Let's go
step by step to learn how each service finds its place.

.. image:: ../../../images/openio-arch-potatoids.svg

The network is the bridge
-------------------------

You might smile and then you would be on the bright side of the IT crowd, but
there is also a dusty side, with plenty of people with smoked glasses and velvet
suits. Those might consider a humongous SAN could be OK.

No way! We target **low-cost** platforms with so large capacities that we can
not afford such niche technologies.


Chunk the data, and store it
----------------------------

Imagine you have a 200TiB storage capacity, made of 1TiB. You now want to store
a single 20TiB file... You got the point, managing **chunks** of the original is
a necessity! Let's keep in mind we will have to save the information to rebuild
the original content, we will manage this later.

Then we need a simple way to PUT/GET/DELETE chunks, a.k.a. blob, on a storage.
No need of a complicated interface, we chosed to mount large disks as regular
filesystem partitions, and expose them behind simple HTTP services managing the
PUT/GET/DELETE. Then the **rawx** service was born.

The job of the service is to allow a quick access to any chunk.

.. image:: ../../../images/openio-arch-blobs.svg


Know where storing chunks
-------------------------

Now we need a functional component that *knows* the state of each service.
We called this service the **conscience**. The services periodically register
in the conscience. They do not mandatorily do this themselves (to keep the
services simple), so the task can be managed by a dedicated process, called
the **conscience-agent**.

Score the services
~~~~~~~~~~~~~~~~~~

What does represent the state of a service from the client's point of view?
Its quality, and we summed it up with a score, a positive integer with a value
ranging from 0 to 100. A score of 0 indicates the service must be avoided.
A positive score means the service can be used, the the bigger it is, the best
the quality will be.

The key factors giving the quality of a service may vary, so the score is
computed though an expression specific for every service type. That way we
can choose the best factors in each expression, with the right weight. E.g. our
chunk storage service depends more on the I/O capability and the disk capacity
than on RAM or CPU.

No SPOF
~~~~~~~

At this point, the conscience is still a real SPOF in the solution if it must
be contacted for each content pushed. Because the conscience's content is not
extremely volatile, it is kept in cache in each service service using it.

But that information might be big and the number of services quite high! So the
sum of all the local caches might be huge. This is why we rather keep a cache
in a local and central process, the **proxy**.

.. image:: ../../../images/openio-arch-conscience.svg

Efficient load-balancing
~~~~~~~~~~~~~~~~~~~~~~~~

You are kindly invited to visit the page dedicated to the `Load Balancing`_.

.. _`Load Balancing`: ./conscience.html

Do hardware tiering
-------------------

Let' give to each service a **storage class**. That information is propagated
to the conscience and becomes a possible criterion to oragnize the services
in slots.


Organize into contents and containers
-------------------------------------

`TODO explain why we choosed individual SQLite files.`

`TODO Present here the SQLite scheme for containers.`


Know where create containers
----------------------------

This is a job for the conscience! Let's give a score expression to the
**meta2** services and let the conscience find the best place for us!


Have many containers
--------------------

A single directory is not enough.
As any search structure, let's find an implementation suitable for an efficient
sharding.

.. image:: ../../../images/openio-arch-directory.svg


Manage lost chunks
------------------

We pushed chunked data, but what if one (or more) chunks are lost?

`TODO explain here about the dulication feature`

`TODO explain here about the erasure coding feature`


Repair lost chunk volumes
-------------------------

`TODO explain here how the rdir was born`


Manage lost containers
----------------------

`TODO explain here about the need for replication`

`TODO explain here why Zookeeper for synchronisation`

`TODO explain here why we use xattr on the chunks`


Provide billing and quotas
--------------------------

`TODO explain here why we manage accounts.`


Tiering on public clouds
------------------------

`TODO explain how we did tiering on BackBlaze B2`


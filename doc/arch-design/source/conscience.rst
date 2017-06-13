==========
Conscience
==========

All OpenIO services are built around the Conscience, it has two main functions:

- **Service Discovery**

- **Load Balancing**

Service Discovery
~~~~~~~~~~~~~~~~~

To find other services available in the namespace, a service uses the
Conscience to discover what kind of services are available and how to
contact them.

Slots
-----
Services can be organized in *slots* by the administrator.
*Slots* are meant to be groups of services sharing common characteristics
like storage media type or physical location. Each service can be in one
or several slots.

There is a default slot for each type of service. If the administrator does
not put a service in a (set of) slot(s), the service will go in the
default slot.

Pools
-----
Pools define the rules that the load-balancer should follow when picking
services. They are configured as a set of *targets*. Each target declares the
number of services to pick, followed by one or more *slots* to use. The slots
will be consumed in the same order as they are declared, thus providing a
fallback mechanism when more that one slot is assigned to a target.

Configuration example (targets are separated by ';'):

::

 targets=2,rawx-europe,rawx-asia;2,rawx-usa,rawx-asia
 min_dist=2

means
 *Take 2 rawx services in Europe (or in Asia if there are no more
 in Europe) and 2 in the USA (or in Asia if there are no more in the USA),
 and ensure a minimum distance of 2 between each service*.

Locations
---------
The administrator can declare the location of each service as a
dot-separated string like ``room1.rack1.server2.volume4`` (1 to 4 words).
The dotted string is internally converted to a 64-bit integer (by hashing
each word using djb2). This allows
finding services that are far from each other when doing erasure coding
or data replication. If no location is set, the IP address and port of
the services are used.

The distance between two services is 4 less the number of words in common,
starting from the left.
``room1.rack1.srv12.vol4`` and ``room1.rack1.srv12.vol5`` have a distance
of 1, ``room1.rack1.srv12.vol4`` and ``room1.rack2.srv11.vol4`` have a
distance of 3.

Load Balancing
~~~~~~~~~~~~~~

Rather than using common round-robin techniques, the Conscience performs
load balancing using real time metrics that are collected from the storage
nodes. A score between 0 and 100 is computed using a configurable formula
and then used to do a weighted random selection.

The usable metrics can really be anything, but most commonly used are:
CPU idle, IO wait, available storage on a volume.

Note that services with low score (at least 1) can still be selected
in the case when no high score service matches location constraints required
by a service pool.

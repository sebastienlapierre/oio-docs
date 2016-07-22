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
 ``2,rawx-europe,rawx-asia;2,rawx-usa,rawx-asia``
means
 *Take 2 rawx services in Europe (or in Asia if there are no more
 in Europe) and 2 in USA (or in Asia if there are no more in USA)*.

Locations
---------
The administrator can declare the location of each service as a
dot-separated string like ``room1.rack1.server2.volume4``. This allows
finding services that are far from each other when doing erasure coding
or data replication. If no location is set, the IP address and port of
the services are used.


Load Balancing
~~~~~~~~~~~~~~

Rather than using common round-robin techniques, the Conscience performs
load balancing using real time metrics that are collected from the storage
nodes. A score between 0 and 100 is computed using a configurable formula
and then used to do a weighted random selection.

The usable metrics can really be anything, but most commonly used are:
CPU idle, IO wait, available storage on a volume.

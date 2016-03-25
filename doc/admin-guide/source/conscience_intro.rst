==========================
Introduction to Conscience
==========================

All OpenIO services are built around the Conscience, it has two main functions:

- **Service Discovery**

- **Load Balancing**

Service Discovery
~~~~~~~~~~~~~~~~~

To find other services available in the namespace, a service uses the
Conscience to discover what kind of services are available and how to
contact them.

Load Balancing
~~~~~~~~~~~~~~

Rather than using common round-robin techniques, the Conscience performs
load balancing using real time metrics that are collected from the storage
nodes. A score between 0 and 100 is computed using a configurable formula.

The usable metrics can really be anything, but most commonly used are:
CPU idle, IO wait, available storage on a volume.

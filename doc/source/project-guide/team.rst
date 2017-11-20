========
The team
========

Our Mission
-----------

OpenIO is an open source object storage solution introduced in 2015 though its
development started 10 years ago. It is built on top of the groundbreaking
concept of “Conscience” allowing dynamic behavior and human-free administration.

Ever wondered how to store multiple petabytes of data without getting
overwhelmed by complex storage tasks and difficult application development? As
object storage is changing the game in enterprise-class storage, most existing
solutions may suffer lack of scalability over the years, with evolving hardware
and capacity needs that increase dramatically. OpenIO’s Conscience technology
deals with this, new hardware is auto-discovered and used right-away at no
performance penalty. Heterogeneity of hardware is the norm, the Conscience is
aware of the performance of each piece of equipment and distributes the load
accordingly. OpenIO solves your storage problem, from 1TB to Exabytes, for the
long term.

OpenIO is an already proven technology at massive scale, especially in email
storage, with 10+ PetaBytes managed.

Our story
---------

It all began in 2006.

Data, in the datacenter of the company we were working for, was exploding at
exponential pace and traditional answers with NAS or SAN storage were
overwhelming for the teams who ran the platforms. This is how the idea of an
Object Storage solution came up. As most of the data we had was made of
immutable objects, it was possible to switch to web-like GET/PUT/DELETE paradigm
instead of the complex POSIX Filesystem API. It was also possible to get rid of
the complex hardware required to run POSIX-like filesystems in a distributed
manner.

Some Object Storage solutions already existed at the time but most of them were
designed for the sole purpose of storing relatively few gigantic files,
addressing large storage capacities with relatively small amount of metadata.
Most of them were based on a single metadata node, avoiding the complexity of a
distributed directory. Most of them were also made for non-production
environments, and were not resilient enough, especially on the metadata side,
with the single metadata node being a single point of failure (SPOF).

Our ambition was to store huge amounts of relatively small files produced by
end-users like emails, eventually using a large storage capacity, but always
accessed with the lowest latency. Also, there was the need for maximum
availability as Service Level Agreements were stricts for these critical
end-user services.

In late 2006, we designed our own solution with a massively distributed
directory. It enabled a true scale-out design:

* each node would carry a part of the directory, i/o intensive metadata load
  would be distributed everywhere
* each new node was going to be immediately used, no need to re-dispatch already
  existing data to get benefits of the new hardware
* data storage was going to be de-correlated from metadata storage, giving true
  scalability on both axis

The solution had also to be hardware agnostic and support heterogeneous
deployments. It had to support multiple hardware vendors and multiple storage
technologies, from simple single drive x86 hosts to high-end NAS and SAN arrays
that were going to be re-used behind x86 servers.

The first production ready version was built in 2008 and the first massive
production of a large scale email system started the year after. Since then, the
solution has been used to store 10+ Petabytes, 10+ billions of objects, at
20 Gbps of bandwidth at the peak hour, with low-latency SLAs enforced 24/7.

As the solution was designed as a general purpose object storage solution, it
was soon used in multiple environments like email, consumer cloud, archiving
(speed control cameras, ...), healthcare systems, voice call recordings, etc.

This Object Storage solution became Open Source in 2012.

Today, OpenIO has the mission to support the open source community, and to make
the solution widely available especially for the most demanding use cases.

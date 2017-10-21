===================
Deployment Overview
===================


Introduction
~~~~~~~~~~~~

OpenIO SDS solution is composed of multiple services, running on commodity hardware, from power efficient systems to high performance servers.
Services are designed to run across multiple nodes and does not requires any specific collocation.

Services are part of different stacks than must be spread over different nodes for high availability concerns and can be optimized depending on their resource needs. For detailed description of services, refer to the architecture design reference.

Front stack
~~~~~~~~~~~
The front stack is composed of the OpenIO Swift proxy server and the Openstack
Keystone stack for authentication.

For high availability, HAproxy is installed as a loadbalancer on the public
interface, and keepalived using VRRP to move the virtual floating IP from one server to another when HAproxy fails. For a better throughput, DNS round-robin offers an optimal solution when performance of front servers is a
concern, replacing HAproxy.

OpenIO Swift proxy
------------------
The OpenIO Swift proxy handles Swift/S3 user requests. It is a stateless service, meaning that it does not store any data and can be easily deployed on any server.

This is a CPU and network intensive service as it serves requests from users and stores the data on the OpenIO SDS core cluster, thus, when configured to use Erasure Coding, computes the data to store to the cluster.

Openstack Keystone
------------------
User authentication and service discovery is done through Openstack Keystone which is accessed directly by the client when using the Swift API, whereas when using S3, Keystone does not need to be publicly exposed. Keystone stores data in a MySQL/MariaDB Galera for high availability. Token caching is achieved using memcached to provide a good level of performance.

Keystone is a CPU bound service, when using the Swift API, token caching allows a rather low usage of Keystone, but when using the S3 API, Keystone access can be something of a concern.

MariaDB Galera cluster
----------------------
MariaDB Galera is a synchronous multi-master cluster for MySQL/MariaDB. It is used as a backend for Openstack Keystone.

MariaDB Galera cluster usage is rather low but requires at least 3 different servers.

HAproxy + keepalived
--------------------
HAproxy is a well known TCP/HTTP loadbalancer. It is used to split service load across different instances. It handles SSL connections aswell acting as a SSL termination. HAproxy loadbalance OpenIO SDS Swift proxy and Openstack Keystone mainly.

HAproxy used in combination of keepalived allows a complete redundancy of services and distributed load across services.

HAproxy is network intensive and when configuring the SSL termination, it is also CPU intensive.

OpenIO SDS
~~~~~~~~~~
OpenIO SDS core solution is divided in multiple simple and lightweight services, which can be easily distributed on different nodes:

- conscience services
- directory services
- data services
- event services
- account services

Conscience services
-------------------
Conscience services are composed of a conscience service which is a multi-master service which we recommend to deploy on at least 3 different servers, and conscienceagent services which are deployed on each server.

On large cluster (depending on the number of services), the conscience services can be CPU and network intensive.

Directory services
------------------
Directory services are the meta0, meta1 and meta2 services, responsible of handling directory requests and store metadatas. Each service type needs to be deployed on at least 3 different servers (different service types can be collocated). meta0 handles a very limited and static entries, and need to be deployed only 3 times, not depending on the size of the cluster. meta1 requires at least 3 instances, and should be considered to be deployed on all the nodes available when configuring the cluster. meta2 follows the same rules than the meta1.

This directory services are multi-master clusters relying on an Apache ZooKeeper cluster for election status.

The oioproxy service is a HTTP directory proxy to easily requests conscience/meta0/meta1 and meta2 services through a simple HTTP API.

Directory services are CPU intensive services that requires a low-latency network for best request times, the meta2 service is also IO bound. We always recommend to store this services on low-latency, high performance storage like SSD or NVMe when available. Zookeeper requires a quite high volume of RAM available to perform at best. The oioproxy is a stateless service which is more CPU intensive but it should not be of a concern.

Data services
-------------
Data services are services responsible of storing and serving the data like the rawx, handling part of the metadata depending on it like the rdir and the oio-blob-indexer.

This services are IO intensive, depending on the size of the objects to be stored. However, rotational disk should be enough here to keep price low. The more disk you have, the more you'll get from the cluster. This services are installed on every disks of the platform.

Event services
--------------
Event services are services than handles asynchronous jobs, it is composed of the oio-event-agent which relies on a beanstalkd backend to manage jobs. This services are deployed on each server.

The oio-event-agent is a CPU intensive stateless service, whereas beanstalkd is more IO intensive. We recommend to deploy beanstalkd on high performance device like SSD or NVMe.

Account services
----------------
The account service is a stateless service, using a Redis Sentinel cluster as a backend. It stores account related informations. The account service requires at least 2 instances but 3 is optimial for small clusters. The Redis Sentinel cluster is composed of 3 instances of Redis Sentinel and Redis backend services.

The account service is CPU bound whereas Redis backend can be more IO intensive.

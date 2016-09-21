Cluster management
==================

Show namespace configuration
----------------------------

To display the namespace configuration:

  .. code-block:: console

   # openio cluster show

    +----------------------------+-----------------------------------------------------------------+
    | Field                      | Value                                                           |
    +----------------------------+-----------------------------------------------------------------+
    | namespace                  | OPENIO                                                          |
    | chunksize                  | 1048576                                                         |
    | storage_policy.EC          | NONE:EC                                                         |
    | storage_policy.SINGLE      | NONE:NONE                                                       |
    | storage_policy.THREECOPIES | rawx3:DUPONETHREE                                               |
    | data_security.DUPONETHREE  | plain/distance=1,nb_copy=3                                      |
    | data_security.EC           | ec/k=6,m=3,algo=liberasurecode_rs_vand,distance=1               |
    [...]
    | storage_policy             | EC                                                              |
    +----------------------------+-----------------------------------------------------------------+


List services
-------------

To list running services in the namespace:

  .. code-block:: console

   # openio cluster list

    +---------+----------------+----------------------+----------+-------+------+-------+
    | Type    | Id             | Volume               | Location | Slots | Up   | Score |
    +---------+----------------+----------------------+----------+-------+------+-------+
    | rawx    | 127.0.0.1:6012 | /data/OPENIO-rawx-1  | oio.vol1 | rawx  | True |    86 |
    | rawx    | 127.0.0.1:6013 | /data/OPENIO-rawx-2  | oio.vol2 | rawx  | True |    86 |
    | rawx    | 127.0.0.1:6014 | /data/OPENIO-rawx-3  | oio.vol3 | rawx  | True |    86 |
    [...]
    | meta2   | 127.0.0.1:6006 | /data/OPENIO-meta2-1 | oio.vol1 | meta2 | True |    86 |
    | meta2   | 127.0.0.1:6007 | /data/OPENIO-meta2-2 | oio.vol2 | meta2 | True |    86 |
    | meta2   | 127.0.0.1:6008 | /data/OPENIO-meta2-3 | oio.vol3 | meta2 | True |    85 |
    | meta1   | 127.0.0.1:6005 | /data/OPENIO-meta1-1 | oio.vol1 | meta1 | True |    85 |
    | meta0   | 127.0.0.1:6004 | /data/OPENIO-meta0-1 | oio.vol1 | meta0 | True |    85 |
    +---------+----------------+----------------------+----------+-------+------+-------+



By default ``cluster list`` command displays all known services.

To list only specific types of services:

  .. code-block:: console

   # openio cluster list rawx meta2

    +---------+----------------+----------------------+----------+-------+------+-------+
    | Type    | Id             | Volume               | Location | Slots | Up   | Score |
    +---------+----------------+----------------------+----------+-------+------+-------+
    | rawx    | 127.0.0.1:6012 | /data/OPENIO-rawx-1  | oio.vol1 | rawx  | True |    86 |
    | rawx    | 127.0.0.1:6013 | /data/OPENIO-rawx-2  | oio.vol2 | rawx  | True |    86 |
    | rawx    | 127.0.0.1:6014 | /data/OPENIO-rawx-3  | oio.vol3 | rawx  | True |    86 |
    [...]
    | meta2   | 127.0.0.1:6006 | /data/OPENIO-meta2-1 | oio.vol1 | meta2 | True |    86 |
    | meta2   | 127.0.0.1:6007 | /data/OPENIO-meta2-2 | oio.vol2 | meta2 | True |    86 |
    | meta2   | 127.0.0.1:6008 | /data/OPENIO-meta2-3 | oio.vol3 | meta2 | True |    85 |
    +---------+----------------+----------------------+----------+-------+------+-------+

Local configuration
-------------------

To display local namespace configuration:

  .. code-block:: console

   # openio cluster local conf

    +--------------------+-----------------------------+
    | Field              | Value                       |
    +--------------------+-----------------------------+
    | OPENIO/conscience  | 127.0.0.1:6002              |
    | OPENIO/zookeeper   | 127.0.0.1:2181              |
    | OPENIO/proxy       | 127.0.0.1:6000              |
    | OPENIO/ecd         | 127.0.0.1:6001              |
    | OPENIO/event-agent | beanstalk://127.0.0.1:11300 |
    +--------------------+-----------------------------+

Score management
----------------

The first time a service is discovered in the namespace, its score is locked at 0.

To unlock a new service:

  .. code-block:: console

   # openio cluster unlock rawx 127.0.0.1:6015

    +------+----------------+----------+
    | Type | Service        | Result   |
    +------+----------------+----------+
    | rawx | 127.0.0.1:6015 | unlocked |
    +------+----------------+----------+

To unlock all registered services:

  .. code-block:: console

   # openio cluster unlockall

    +-------+----------------+----------+
    | Type  | Service        | Result   |
    +-------+----------------+----------+
    | meta2 | 127.0.0.1:6006 | unlocked |
    | meta2 | 127.0.0.1:6007 | unlocked |
    | meta2 | 127.0.0.1:6008 | unlocked |
    [...]
    | rawx  | 127.0.0.1:6014 | unlocked |
    | rawx  | 127.0.0.1:6015 | unlocked |
    +-------+----------------+----------+

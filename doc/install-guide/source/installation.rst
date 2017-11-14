============
Installation
============

Initialize
~~~~~~~~~~

.. only:: ubuntu or debian or raspbian

  .. include:: ../../install-common/source/initialize_debian.rst

.. only:: centos

  .. include:: ../../install-common/source/initialize_centos.rst

OpenIO Packages Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. only:: centos

  .. include:: ../../install-common/source/packages_configuration_centos.rst

.. only:: ubuntu

  .. include:: ../../install-common/source/packages_configuration_ubuntu.rst

.. only:: debian

  .. include:: ../../install-common/source/packages_configuration_debian.rst

.. only:: raspbian

  .. include:: ../../install-common/source/packages_configuration_raspbian.rst

Puppet Manifest
~~~~~~~~~~~~~~~

Now you can create a manifest file to configure each host,
here is a template to configure the services:

- In this case, its assumed that service will be deployed on the first network device, you can check the ipaddress used on the server with the command ``facter ipaddress``. You can change the device used by either replace ``$ipaddress`` on top of the manifest by the IP address of your choice or using a facter fact (example: ``$ipaddress_enp0s8`` or ``$ipaddress_eth1``).
- On the server 2 and 3, add ``slaveof => 'SERVER1 6011',`` in the redis block.
- Replace SERVER1, SERVER2 and SERVER3 with the corresponding IP addresses.

In a file called ``/root/openio.pp``:

   .. code-block:: puppet

    $ipaddr = $ipaddress
    class {'openiosds':}
    openiosds::conscience {'conscience-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::namespace {'OPENIO':
      ns                       => 'OPENIO',
      conscience_url           => "SERVER1:6000",
      zookeeper_url            => "SERVER1:6005,SERVER2:6005,SERVER3:6005",
      oioproxy_url             => "${ipaddr}:6006",
      eventagent_url           => "beanstalk://${ipaddr}:6014",
      ns_service_update_policy => {'meta2'=>'KEEP|3|1|','sqlx'=>'KEEP|3|1|','rdir'=>'KEEP|1|1|user_is_a_service=rawx'},
      ns_storage_policy        => 'THREECOPIES',
    }
    openiosds::account {'account-0':
      ns                   => 'OPENIO',
      ipaddress            => $ipaddr,
      sentinel_hosts       => 'SERVER1:6012,SERVER2:6012,SERVER3:6012',
      sentinel_master_name => 'OPENIO-master-1',
    }
    openiosds::meta0 {'meta0-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::meta1 {'meta1-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::meta2 {'meta2-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::rawx {'rawx-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::oioeventagent {'oio-event-agent-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::oioproxy {'oioproxy-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::zookeeper {'zookeeper-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
      servers   => ['SERVER1:2888:3888','SERVER2:2888:3888','SERVER3:2888:3888'],
    }
    openiosds::redissentinel {'redissentinel-0':
      ns          => 'OPENIO',
      ipaddress   => $ipaddr,
      master_name => 'OPENIO-master-1',
      redis_host  => "SERVER1",
    }
    openiosds::redis {'redis-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::conscienceagent {'conscienceagent-0':
      ns => 'OPENIO',
    }
    openiosds::beanstalkd {'beanstalkd-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::rdir {'rdir-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::oioblobindexer {'oio-blob-indexer-rawx-0':
      ns => 'OPENIO',
    }


Package Installation and Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will install the packages and configure the services for your OpenIO namespace.
On each server, apply the manifest:

   .. code-block:: console

      # sudo puppet apply --no-stringify_facts /root/openio.pp

This step may take a few minutes. Please be patient as it downloads and installs all necessary packages.
Once completed, all services should be installed and running using OpenIO GridInit.
You can verify that everything went well by performing ``sudo gridinit_cmd status`` on every node.

    .. code-block:: console

       KEY                           STATUS      PID GROUP
       NAMESPACE-servicetype-idx     UP          pid NAMESPACE,service,servicetype-idx
       ...

Initialize OpenIO Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~

As you may have noticed the namespace is, by default, called ``OPENIO``.  The namespace must remain ``OPENIO`` for the following steps to work properly.

Next, we need to initialize a few components, namely ZooKeeper and meta0.

#. Zookeeper Bootstrap:

   .. code-block:: console

      # sudo zk-bootstrap.py OPENIO

   .. note::

      This step can be performed on any one of the servers.

#. Verify that after a few seconds `meta0` and `meta1` services are registered in the ``conscience``:

   .. code-block:: console

      # openio --oio-ns OPENIO cluster list

   .. note::

      This command can be performed on any one of the servers.

   **openio cluster list output**

   .. code-block:: console

      +---------+-----------------+---------------------------------+----------+-------+------+-------+
      | Type    | Id              | Volume                          | Location | Slots | Up   | Score |
      +---------+-----------------+---------------------------------+----------+-------+------+-------+
      | rdir    | 10.0.0.171:6010 | /var/lib/oio/sds/OPENIO/rdir-0  | node-1   | n/a   | True |    96 |
      | rdir    | 10.0.0.172:6010 | /var/lib/oio/sds/OPENIO/rdir-0  | node-2   | n/a   | True |    98 |
      | rdir    | 10.0.0.173:6010 | /var/lib/oio/sds/OPENIO/rdir-0  | node-3   | n/a   | True |    97 |
      | account | 10.0.0.171:6009 | n/a                             | node-1   | n/a   | True |    96 |
      | account | 10.0.0.172:6009 | n/a                             | node-2   | n/a   | True |    99 |
      | account | 10.0.0.173:6009 | n/a                             | node-3   | n/a   | True |    97 |
      | rawx    | 10.0.0.171:6004 | /var/lib/oio/sds/OPENIO/rawx-0  | node-1   | n/a   | True |    85 |
      | rawx    | 10.0.0.173:6004 | /var/lib/oio/sds/OPENIO/rawx-0  | node-3   | n/a   | True |    95 |
      | rawx    | 10.0.0.172:6004 | /var/lib/oio/sds/OPENIO/rawx-0  | node-2   | n/a   | True |    94 |
      | meta2   | 10.0.0.171:6003 | /var/lib/oio/sds/OPENIO/meta2-0 | node-1   | n/a   | True |    94 |
      | meta2   | 10.0.0.172:6003 | /var/lib/oio/sds/OPENIO/meta2-0 | node-2   | n/a   | True |    94 |
      | meta2   | 10.0.0.173:6003 | /var/lib/oio/sds/OPENIO/meta2-0 | node-3   | n/a   | True |    94 |
      | meta1   | 10.0.0.171:6002 | /var/lib/oio/sds/OPENIO/meta1-0 | node-1   | n/a   | True |    94 |
      | meta1   | 10.0.0.172:6002 | /var/lib/oio/sds/OPENIO/meta1-0 | node-2   | n/a   | True |    94 |
      | meta1   | 10.0.0.173:6002 | /var/lib/oio/sds/OPENIO/meta1-0 | node-3   | n/a   | True |    94 |
      | meta0   | 10.0.0.171:6001 | /var/lib/oio/sds/OPENIO/meta0-0 | node-1   | n/a   | True |   100 |
      | meta0   | 10.0.0.172:6001 | /var/lib/oio/sds/OPENIO/meta0-0 | node-2   | n/a   | True |    99 |
      | meta0   | 10.0.0.173:6001 | /var/lib/oio/sds/OPENIO/meta0-0 | node-3   | n/a   | True |    98 |
      +---------+-----------------+---------------------------------+----------+-------+------+-------+


#. `meta0` service initialization:

   First, unlock all services in the namespace:

   .. code-block:: console

      # openio --oio-ns=OPENIO cluster unlockall

   .. note::

       This command can be performed on any one of the servers.


   Then, bootstrap the directory:

   .. code-block:: console

      # openio --oio-ns=OPENIO directory bootstrap --replicas 3

   .. note::

      We specify here that meta1 services will have 3 replicas.

   .. note::

      This command can be performed on any one of the servers.

#. `meta0` and `meta1` restart

   Restart the meta0 and the meta1 services on each server:

   .. code-block:: console

      # sudo gridinit_cmd restart @meta0 @meta1

   .. warning::

      Must be performed on all servers

#. Start all services:

   .. code-block:: console

      # sudo gridinit_cmd start

   .. warning::

      Must be performed on all servers

   **gridinit_cmd status output**

   .. code-block:: console

      KEY                       STATUS      PID GROUP
      OPENIO-account-0          UP          621 OPENIO,account,account-0
      OPENIO-beanstalkd-0       UP          764 OPENIO,beanstalkd,beanstalkd-0
      OPENIO-conscienceagent-0  UP          622 OPENIO,conscienceagent,conscienceagent-0
      OPENIO-meta0-0            UP          687 OPENIO,meta0,meta0-0
      OPENIO-meta1-0            UP          686 OPENIO,meta1,meta1-0
      OPENIO-meta2-0            UP          685 OPENIO,meta2,meta2-0
      OPENIO-oio-blob-indexer-0 UP          616 OPENIO,oio-blob-indexer,oio-blob-indexer-0
      OPENIO-oio-event-agent-0  UP          617 OPENIO,oio-event-agent,oio-event-agent-0
      OPENIO-oioproxy-0         UP          683 OPENIO,oioproxy,oioproxy-0
      OPENIO-rawx-0             UP          741 OPENIO,rawx,rawx-0
      OPENIO-rdir-0             UP          615 OPENIO,rdir,rdir-0
      OPENIO-redis-0            UP          684 OPENIO,redis,redis-0
      OPENIO-redissentinel-0    UP          614 OPENIO,redissentinel,redissentinel-0
      OPENIO-zookeeper-0        UP          612 OPENIO,zookeeper,zookeeper-0

#. Unlock all services:

   Finally, unlock all services in the namespace:

   .. code-block:: console

      # openio --oio-ns=OPENIO cluster unlockall

   .. note::

      This command can be performed on any one of the servers.


   After unlocking, your OPENIO namespace should be running!

   Be sure that every score is greater that 0 using `openio cluster list`:

   .. code-block:: console

      # openio --oio-ns OPENIO cluster list

   .. TODO ADD test installation section

#. All done !

   Now you have your 3 nodes ready for testing purpose, and the proxy is accessible at http://YOUR_SERVER_IP:6006 (port 6006 by default as mentioned in the puppet manifest *(oioproxy_url)* )

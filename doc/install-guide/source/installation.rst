============
Installation
============

Initialize
~~~~~~~~~~

#. Keep your system updated:

   .. only:: ubuntu or debian
   
      .. code-block:: console
           
         # apt-get update 
         # apt-get upgrade
   
   .. only:: centos
   
      .. code-block:: console 
   
         # yum update -y

#. Disable SELinux:
   
   .. code-block:: console
  
      # sed -i -e 's@^SELINUX=enforcing$@SELINUX=disabled@g' /etc/selinux/config
   
#. Disable firewalld:
   
   .. code-block:: console
 
      # systemctl stop firewalld.service ; systemctl disable firewalld.service

#. To take this change into account, reboot:

   .. code-block:: console

      # reboot

OpenIO Packages Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On each servers:

#. Install OpenIO repository package:

   .. only:: centos
   
      .. code-block:: console
   
         # yum -y install http://mirror.openio.io/pub/repo/openio/sds/15.12/el/openio-sds-release-15.12-1.el.noarch.rpm
   
   .. only:: ubuntu
      
      We provide a shell script (relying on Puppet) that allows you to install easily a namespace named *OPENIO*
      
      Add the repository configuration
   
      .. code-block:: console
   
         # echo "deb http://mirror.openio.io/pub/repo/openio/sds/16.04/$(lsb_release -i -s)/ $(lsb_release -c -s)/" | sudo tee /etc/apt/sources.list.d/openio-sds.list
   
      Add the OpenIO archive key

      .. code-block:: console
   
         # curl http://mirror.openio.io/pub/repo/openio/APT-GPG-KEY-OPENIO-0 | apt-key add -

#. Install OpenIO puppet module:

   .. only:: centos
   
      .. code-block:: console
   
         # yum -y install puppet-openio-sds

   .. only:: ubuntu
   
      .. code-block:: console
   
         # apt install puppet-common
         # puppet module install openio-openiosds
   

Puppet Manifest
~~~~~~~~~~~~~~~

Now you can create a manifest file to configure each host,
here is a template that will help you configure the services:

- Replace SERVER1, SERVER2 and SERVER3 with the corresponding IP addresses.
- On each server, replace ``MYID`` by the number of server: 1, 2 or 3.
- On the server 2 and 3, add ``slaveof => 'SERVER1 6011'`` in the redis block
- The `conscience` service is not necessary on SERVER2 and SERVER3, you `MUST` remove it.

In a file called ``/root/openio.pp``:

   .. code-block:: puppet
   
      class {'openiosds':}
      openiosds::conscience {'conscience-0':
        ns                    => 'OPENIO',
        ipaddress             => $ipaddress,
        service_update_policy => 'meta2=KEEP|3|1|;rdir=KEEP|1|1|user_is_a_service=1',
        storage_policy        => 'THREECOPIES',
        meta2_max_versions    => '1',
      }
      openiosds::namespace {'OPENIO':
        ns             => 'OPENIO',
        conscience_url => "SERVER1:6000",
        zookeeper_url  => "SERVER1:6005,SERVER2:6005,SERVER3:6005",
        oioproxy_url   => "${ipaddress}:6006",
        eventagent_url => "beanstalk://${ipaddress}:6014",
      }
      openiosds::account {'account-0':
        ns                    => 'OPENIO',
        ipaddress             => $ipaddress,
        sentinel_hosts        => 'SERVER1:6012,SERVER2:6012,SERVER3:6012',
        sentinel_master_name  => 'OPENIO-master-1',
      }
      openiosds::meta0 {'meta0-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::meta1 {'meta1-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::meta2 {'meta2-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::rawx {'rawx-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::oioeventagent {'oio-event-agent-0':
        ns          => 'OPENIO',
        ipaddress   => $ipaddress,
      }
      openiosds::oioproxy {'oioproxy-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::zookeeper {'zookeeper-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
        servers   => ['SERVER1:2888:3888','SERVER2:2888:3888','SERVER3:2888:3888'],
        myid      => MYID,
      }
      openiosds::redissentinel {'redissentinel-0':
        ns        => 'OPENIO',
        master_name => 'OPENIO-master-1',
        redis_host => "SERVER1",
      }
      openiosds::redis {'redis-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::conscienceagent {'conscienceagent-0':
        ns  => 'OPENIO',
      }
      openiosds::beanstalkd {'beanstalkd-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::rdir {'rdir-0':
        ns        => 'OPENIO',
        ipaddress => $ipaddress,
      }
      openiosds::oioblobindexer {'oio-blob-indexer-rawx-0':
        ns  => 'OPENIO',
      }

Package Installation and Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will install the packages and configure the services for your OpenIO namespace.
On each server, apply the manifest:

   .. code-block:: console

      # puppet apply --no-stringify_facts /root/openio.pp

This step will download and install all necessary packages, so it will take
a few minutes depending on your Internet connection speed.
At the end, services should be installed and running using OpenIO GridInit.


Initialize OpenIO Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~

As you may have notice, our namespace is called ``OPENIO``, we need to initialize a few components, namely ZooKeeper and our meta0.

#. Zookeeper Bootstrap:

   .. code-block:: console

      # zk-bootstrap.py OPENIO

   .. note::

      This step can be performed on any one of the servers.

#. Verify that after a few seconds `meta0` and `meta1` services are registered in the ``conscience``:

   .. code-block:: console

      # oio-cluster OPENIO

   .. note::

      This command can be performed on any one of the servers.

   **oio-cluster output**

   .. code-block:: console 

      NAMESPACE INFORMATION
      
                    Name : OPENIO
                    Chunk size : 10485760 bytes
                    Option : automatic_open = true
                    Option : events-max-pending = 1000
                    Option : lb.rawx = WRAND
                    Option : lb.rdir = WRAND?shorten_ratio=1.0&standard_deviation=no
                    Option : meta1.events-max-pending = 1000
                    Option : meta2.events-max-pending = 1000
                    Option : meta2_check.put.DISTANCE = false
                    Option : meta2_check.put.GAPS = false
                    Option : meta2_check.put.SRVINFO = false
                    Option : meta2_check.put.STGCLASS = false
                    Option : meta2_max_versions = 1
                    Option : ns_status = STANDALONE
                    Option : service_update_policy = meta2=KEEP|3|1|;rdir=KEEP|1|1|user_is_a_service=1
                    Option : storage_policy = THREECOPIES
                    Option : WORM = false
            Storage Policy : FIVECOPIES = NONE:DUPONEFIVE:NONE
            Storage Policy : RAIN = NONE:RAIN:NONE
            Storage Policy : SINGLE = NONE:NONE:NONE
            Storage Policy : THREECOPIES = NONE:DUPONETHREE:NONE
            Storage Policy : TWOCOPIES = NONE:DUPONETWO:NONE
            Storage Policy : UNSAFETHREECOPIES = NONE:DUPZEROTHREE:NONE
             Storage Class : PRETTYGOOD = REASONABLYSLOW,NONE
             Storage Class : REASONABLYSLOW = NONE
             Storage Class : SUPERFAST = PRETTYGOOD,REASONABLYSLOW,NONE
             Data Security : DUPONEFIVE = DUP:distance=1|nb_copy=5
             Data Security : DUPONETHREE = DUP:distance=1|nb_copy=3
             Data Security : DUPONETWO = DUP:distance=1|nb_copy=2
             Data Security : DUPZEROTHREE = DUP:distance=0|nb_copy=3
             Data Security : RAIN = RAIN:k=6|m=2|algo=liber8tion
                   LB(srv) : meta2=KEEP|3|1;rdir=KEEP|1|1|user_is_a_service=1
                           : sqlx -> KEEP|1|1
                           : oiofs -> KEEP|1|1
                           : meta0 -> KEEP|1|1
                           : meta1 -> KEEP|1|1
                           : meta2 -> KEEP|3|1
                           : redis -> KEEP|1|1
                           : rainx -> KEEP|1|1
                           : rawx -> KEEP|1|1
                           : account -> KEEP|1|1
                           : rdir -> KEEP|1|1
                 LB(meta2) : sqlx=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : oiofs=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : meta0=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : meta1=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : meta2=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : redis=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : rainx=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : rawx=WRAND?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : account=WRR?shorten_ratio=1.001000&standard_deviation=no&reset_delay=60
                           : rdir=WRAND?shorten_ratio=1.000000&standard_deviation=no&reset_delay=60
      
      
      -- meta0 --
         192.168.1.34:6001                       0
         192.168.1.31:6001                       0
         192.168.1.33:6001                       0
      
      -- meta1 --
         192.168.1.34:6002                       0
         192.168.1.31:6002                       0
         192.168.1.33:6002                       0
      
      -- meta2 --
         192.168.1.34:6003                       0
         192.168.1.31:6003                       0
         192.168.1.33:6003                       0
      
      -- rawx --
         192.168.1.34:6004                       0
         192.168.1.31:6004                       0
         192.168.1.33:6004                       0
      
      -- account --
         192.168.1.31:6009                       0
         192.168.1.34:6009                       0
         192.168.1.33:6009                       0
      
      -- rdir --
         192.168.1.34:6010                       0
         192.168.1.31:6010                       0
         192.168.1.33:6010                       0
      

#. `meta0` service initialization:

   .. code-block:: console

      # oio-meta0-init -O NbReplicas=3 OPENIO

   .. note::

      We specify here that meta1 services will have 3 replicas.


#. `meta0` and `meta1` restart

   To finish the install, restart the meta0 and the meta1 services on every servers:

   .. code-block:: console

      # gridinit_cmd restart @meta0 ; gridinit_cmd restart @meta1

   .. warning::

      Must be perform on all servers

#. Start all services:

   .. code-block:: console

      # gridinit_cmd start

   .. warning::

      Must be perform on all servers

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

   .. TODO ADD test installation section

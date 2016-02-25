============
Installation
============

Initialize
~~~~~~~~~~

#. Update your system:

   .. code-block:: console

      # yum update -y

#. Disable SELinux:

   .. code-block:: console

      # sed -i -e 's@^SELINUX=enforcing$@SELINUX=disabled@g' /etc/selinux/config

#. Disable firewalld:

   .. code-block:: console

      # systemctl stop firewalld.service ; systemctl disable firewalld.service

#. To take this changes into account, reboot:

   .. code-block:: console

      # reboot


OpenIO Packages Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On each servers:

#. Install OpenIO repository package:

   .. code-block:: console

      # yum -y install http://mirror.openio.io/pub/repo/openio/sds/15.12/el/openio-sds-release-15.12-1.el.noarch.rpm


#. Install OpenIO puppet module:

   .. code-block:: console

      # yum -y install puppet-openio-sds


Puppet Manifest
~~~~~~~~~~~~~~~

Now you can create a manifest file to configure each host,
here is a template that will help you configure the services:

- Replace SERVER1, SERVER2 and SERVER3 with the corresponding IP addresses.
- On each server, replace ``myid`` by the number of server: 1, 2 or 3.
- The `conscience` and `account` service sections `MUST` be removed on SERVER2 and SERVER 3.

Create a file ``openio.pp``:

   .. code-block:: puppet

     openiosds::account {'account-0':
        ns                    => 'OPENIO',
        ipaddress             => $ipaddress,
        redis_default_install => true,
        redis_host            => '127.0.0.1',
        redis_port            => '6379',
      }
      openiosds::conscience {'conscience-0':
        ns                    => 'OPENIO',
        ipaddress             => $ipaddress,
        service_update_policy => 'meta2=KEEP|3|1|',
        storage_policy        => 'THREECOPIES',
        meta2_max_versions    => '1',
      }
      openiosds::sdsagent {'sds-agent-0':
      }
      openiosds::namespace {'OPENIO':
        ns             => 'OPENIO',
        conscience_url => "SERVER1:6000",
        zookeeper_url  => "SERVER1:6005,SERVER2:6005,SERVER3:6005",
        oioproxy_url   => "${ipaddress}:6006",
        eventagent_url => "tcp://${ipaddress}:6008",
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
        myid      => 1,
      }


Package Installation and Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will install the packages and configure the services for your OpenIO namespace.
On each server, apply the manifest:

   .. code-block:: console

      # puppet apply openio.pp

This step will download and install all necessary packages, so it will take
a few minutes depending on your Internet connection speed.


Initialize OpenIO Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~

We created a namespace called ``OPENIO``, we now need to initialize it.


#. Zookeeper Bootstrap:

   .. code-block:: console

      # zk-bootstrap.py OPENIO

.. note::

   This step can be performed on any one of the servers.

#. Verify that after a few seconds `meta0` and `meta1` services are registered in the ``conscience``:

   .. code-block:: console

      # oio-cluster OPENIO

.. TODO ADD oio-cluster output

.. note::

   This command can be performed on any one of the servers.


#. `meta0` service initialization:

   .. code-block:: console

      # oio-meta0-init -O NbReplicas=3 OPENIO

.. note::

   We specify here that meta1 services will have 3 replicas.


#. `meta0` and `meta1` restart:

   .. code-block:: console

      # gridinit_cmd restart @meta0 ; gridinit_cmd restart @meta1

#. Start all services:

   .. code-block:: console

      # gridinit_cmd start

.. TODO ADD output to verify install

.. TODO ADD test installation section

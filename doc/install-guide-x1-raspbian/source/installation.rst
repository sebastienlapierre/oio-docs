============
Installation
============

Initialize
~~~~~~~~~~

  .. include:: ../../install-common/source/initialize_raspbian.rst

OpenIO Packages Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  .. include:: ../../install-common/source/packages_configuration_raspbian.rst

Puppet Manifest
~~~~~~~~~~~~~~~

Now you can create a manifest file to configure OpenIO on the Raspberry Pi to run in standalone mode.

In a file called ``~/openio.pp``:

   .. code-block:: puppet

    # Default ipaddress to use
    $ipaddr = $ipaddress
    # Comma separated list of 'project:user:passwd:privileges'
    $default_tempauth_users = ['demo:demo:DEMO_PASS:.admin']
    
    # Deploy a single node
    class{'openiosds':}
    openiosds::namespace {'OPENIO':
      ns             => 'OPENIO',
      conscience_url => "${ipaddr}:6000",
      oioproxy_url   => "${ipaddr}:6006",
      eventagent_url => "beanstalk://${ipaddr}:6014",
      meta1_digits   => 0,
    }
    openiosds::account {'account-0':
      ns         => 'OPENIO',
      ipaddress  => $ipaddr,
      redis_host => $ipaddr,
    }
    openiosds::conscience {'conscience-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
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
    openiosds::rdir {'rdir-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
      location  => "${hostname}-other",
    }
    openiosds::oioblobindexer {'oio-blob-indexer-rawx-0':
      ns        => 'OPENIO',
    }
    openiosds::oioeventagent {'oio-event-agent-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::oioproxy {'oioproxy-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::redis {'redis-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::conscienceagent {'conscienceagent-0':
      ns        => 'OPENIO',
    }
    openiosds::beanstalkd {'beanstalkd-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }
    openiosds::oioswift {'oioswift-0':
      ns               => 'OPENIO',
      ipaddress        => '0.0.0.0',
      sds_proxy_url    => "http://${ipaddr}:6006",
      auth_system      => 'tempauth',
      tempauth_users   => $default_tempauth_users,
      memcache_servers => "${ipaddr}:6019",
    }
    openiosds::memcached {'memcached-0':
      ns        => 'OPENIO',
      ipaddress => $ipaddr,
    }

   .. note::
      - You can change the interface to be used to install OpenIO SDS by replacing ``$ipaddress`` by another IP of another interface on your Raspberry Pi. Defaults to the IP of the first interface. Note that name are not supported.
      - You can change the default credentials by modifying ``demo:demo:DEMO_PASS:.admin`` according to your needs. It is a comma separated list of *'project:user:password:role'[,..]*


Package Installation and Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will install the packages and configure the services for your OpenIO namespace.
To do so, just apply the manifest created earlier:

   .. code-block:: console

      $ sudo puppet apply --no-stringify_facts ~/openio.pp

This step may take a few minutes. Please be patient as it downloads and installs all necessary packages.
When it's done, you can stop and disable the default services that are unecessary:


   .. code-block:: console

      $ sudo systemctl stop apache2 memcached redis beanstalkd puppet
      $ sudo systemctl disable apache2 memcached redis beanstalkd puppet


Initialize OpenIO Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~

As you may have noticed the namespace is, by default, called ``OPENIO``.  The namespace must remain ``OPENIO`` for the following steps to work properly.

#. `meta0` service initialization:

   First, unlock all services in the namespace:

   .. code-block:: console

      $ openio --oio-ns=OPENIO cluster unlockall


   Bootstrap the directory:

   .. code-block:: console

      $ openio --oio-ns=OPENIO directory bootstrap --no-rdir

#. `meta0` and `meta1` restart

   Restart the meta0 and the meta1 services on each server:

   .. code-block:: console

      $ sudo gridinit_cmd restart @meta0 @meta1

#. Unlock all services:

   Finally, unlock all services in the namespace:

   .. code-block:: console

      $ openio --oio-ns=OPENIO cluster unlockall

#. Assign the rawx to a rdir

   .. code-block:: console

      $ openio --oio-ns=OPENIO volume admin bootstrap


Be sure that every score is greater that 0 using `openio cluster list`:

   .. code-block:: console

      $ openio --oio-ns OPENIO cluster list

Your namespace is now up and running!

   .. TODO ADD test installation section

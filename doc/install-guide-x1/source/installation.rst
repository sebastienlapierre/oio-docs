============
Installation
============

Initialize
~~~~~~~~~~

  .. include:: ../../install-common/source/initialize_raspbian.rst

OpenIO Packages Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  .. include:: ../../install-common/source/packages_configuration_debian.rst

Puppet Manifest
~~~~~~~~~~~~~~~

Now you can create a manifest file to configure OpenIO on the Raspberry Pi to run in standalone mode.

In a file called ``~/openio.pp``:

   .. code-block:: puppet

    class {'openiosds': }
    openiosds::namespace {'OPENIO':
       ns => 'OPENIO',
       conscience_url => "${ipaddress}:6000",
       oioproxy_url => "${ipaddress}:6006",
       eventagent_url => "beanstalk://${ipaddress}:6014",
       meta1_digits => 3,
    }
    openiosds::conscience {'conscience-0':
      ns => 'OPENIO',
    }
    openiosds::meta0 {'meta0-0':
      ns => 'OPENIO',
    }
    openiosds::meta1 {'meta1-0':
      ns => 'OPENIO',
    }
    openiosds::meta2 {'meta2-0':
      ns => 'OPENIO',
    }
    openiosds::rawx {'rawx-0':
      ns => 'OPENIO',
    }
    openiosds::account {'account-0':
      ns => 'OPENIO',
    }
    openiosds::oioeventagent {'oio-event-agent-0':
      ns => 'OPENIO',
    }
    openiosds::oioproxy {'oioproxy-0':
      ns => 'OPENIO',
    }
    openiosds::conscienceagent {'conscienceagent-0':
      ns => 'OPENIO',
    }
    openiosds::rdir {'rdir-0':
      ns => 'OPENIO',
      location => "${hostname}-other",
    }
    openiosds::redis {'redis-0':
      ns => 'OPENIO',
    }
    openiosds::beanstalkd {'beanstalkd-0':
      ns => 'OPENIO',
    }

Package Installation and Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will install the packages and configure the services for your OpenIO namespace.
To do so, just apply the manifest created earlier:

   .. code-block:: console

      # sudo puppet apply --no-stringify_facts openio.pp

This step may take a few minutes. Please be patient as it downloads and installs all necessary packages.


Initialize OpenIO Namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~

As you may have noticed the namespace is, by default, called ``OPENIO``.  The namespace must remain ``OPENIO`` for the following steps to work properly.

#. `meta0` service initialization:

   First, unlock all services in the namespace:

   .. code-block:: console

      # openio --oio-ns=OPENIO cluster unlockall


   Then, bootstrap the directory:

   .. code-block:: console

      # openio --oio-ns=OPENIO directory bootstrap


#. `meta0` and `meta1` restart

   Restart the meta0 and the meta1 services on each server:

   .. code-block:: console

      # gridinit_cmd restart @meta0 @meta1

#. Unlock all services:

   Finally, unlock all services in the namespace:

   .. code-block:: console

      # openio --oio-ns=OPENIO cluster unlockall


   After unlocking, your OPENIO namespace should be running!

   Be sure that every score is greater that 0 using `openio cluster list`:

   .. code-block:: console

      # openio --oio-ns OPENIO cluster list

   .. TODO ADD test installation section

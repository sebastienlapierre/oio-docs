============
Installation
============

Initialize
~~~~~~~~~~

.. only:: ubuntu or debian

  .. include:: ../../install-common/source/initialize_debian.rst

.. only:: centos

  .. include:: ../../install-common/source/initialize_centos.rst

Repositories Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. only:: centos

  .. include:: ../../install-common/source/packages_configuration_centos.rst

.. only:: ubuntu

  .. include:: ../../install-common/source/packages_configuration_ubuntu.rst

.. only:: debian

  .. include:: ../../install-common/source/packages_configuration_debian.rst

3. Install the OpenStack repository

   .. only:: centos

      .. code-block:: console

         # yum -y install centos-release-openstack-mitaka

   .. only:: debian

      .. code-block:: console
         
         # curl http://mitaka-$(lsb_release -c -s).pkgs.mirantis.com/debian/dists/pubkey.gpg | sudo apt-key add -

         # echo "deb http://mitaka-$(lsb_release -c -s).pkgs.mirantis.com/$(lsb_release -i -s) $(lsb_release -c -s)-mitaka-backports main" | sudo tee /etc/apt/sources.list.d/mitaka.list

Prerequisites
~~~~~~~~~~~~~

The OpenStack Swift proxy requires memcached. We use the system default install:

   .. only:: centos

      .. code-block:: console

         # yum -y install memcached

         # systemctl enable memcached.service

         # systemctl start memcached.service


   .. only:: ubuntu or debian

      .. code-block:: console

         # sudo apt-get update

         # sudo apt-get install memcached


Installation
~~~~~~~~~~~~

We will use the OpenStack modules to install and configure OpenStack KeyStone. First, install Puppet:

     .. only:: centos

      .. code-block:: console

         # yum -y install puppet

   .. only:: ubuntu or debian

      .. code-block:: console

         # sudo apt-get install puppet

Install the module:

   .. only:: ubuntu or debian

      .. code-block:: console

         # puppet module install openstack-keystone

   .. only:: ubuntu

      .. code-block:: console

         # sed -i "s@'upstart'@undef@" /etc/puppet/modules/keystone/manifests/params.pp

   .. only:: centos

      .. code-block:: console

         # puppet module install openstack-keystone

Install OpenIO Puppet module:

     .. only:: centos

      .. code-block:: console

         # yum -y install puppet-openio-sds

   .. only:: ubuntu or debian

      .. code-block:: console

         # sudo apt-get install puppet-module-openio-openiosds

Puppet Manifest
~~~~~~~~~~~~~~~

Here is an example manifest you can tune to your own settings:

- `sds_proxy_url` should point to an oioproxy service. `6006` is the default port, so you can just change the `OIO_SERVER` to another server where OpenIO is installed.
- `admin_token` is used for KeyStone administrative purpose only.
- Change the password fields.
- The `demo` user will be created for testing purpose, following the example of the OpenStack KeyStone documentation.

In a file called ``/root/openio.pp``:

   .. code-block:: puppet

    class { 'keystone':
      verbose             => True,
      admin_token         => 'KEYSTONE_ADMIN_UUID',
      database_connection => 'sqlite:////var/lib/keystone/keystone.db',
    }

    # Adds the admin credential to keystone.
    class { 'keystone::roles::admin':
      email    => 'test@openio.io',
      password => 'ADMIN_PASS',
      admin               => 'admin',
      admin_tenant        => 'admin',
      admin_user_domain   => 'admin',
      admin_project_domain => 'admin',
    }

    # Installs the service user endpoint.
    class { 'keystone::endpoint':
      public_url   => "http://${ipaddress}:5000",
      admin_url    => "http://${ipaddress}:5000",
      internal_url => "http://${ipaddress}:35357",
      region       => 'localhost-1',
    }

    # Swift
    keystone_user { 'swift':
      ensure   => present,
      enabled  => True,
      password => 'SWIFT_PASS',
    }
    keystone_user_role { 'swift@services':
      roles  => ['admin'],
      ensure => present
    }
    keystone_service { 'openio-swift':
      ensure      => present,
      type        => 'object-store',
      description => 'OpenIO SDS swift proxy',
    }
    keystone_endpoint { 'localhost-1/openio-swift':
      ensure       => present,
      type         => 'object-store',
      public_url   => "http://${ipaddress}:6007/v1.0/AUTH_%(tenant_id)s",
      admin_url    => "http://${ipaddress}:6007/v1.0/AUTH_%(tenant_id)s",
      internal_url => "http://${ipaddress}:6007/v1.0/AUTH_%(tenant_id)s",
    }

    # Demo account
    keystone_tenant { 'demo':
      ensure  => present,
      enabled => True,
    }
    keystone_user { 'demo':
      ensure  => present,
      enabled => True,
      password => "DEMO_PASS",
    }
    keystone_role { '_member_':
      ensure => present,
    }
    keystone_user_role { 'demo@demo':
      roles  => ['admin','_member_'],
      ensure => present
    }
    class {'openiosds':}
    openiosds::namespace {'OPENIO':
        ns => 'OPENIO',
    }
    openiosds::oioswift {'oioswift-0':
      ns             => 'OPENIO',
      ipaddress      => '0.0.0.0',
      sds_proxy_url  => 'http://OIO_SERVER:6006',
      admin_password => 'SWIFT_PASS',
    }


Package Installation and Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will install the packages and configure the services.
Apply the manifest:

   .. code-block:: console

      # puppet apply --no-stringify_facts /root/openio.pp

This step may take a few minutes. Please be patient as it downloads and installs all necessary packages.
Once completed, all services should be installed and running using OpenIO GridInit.

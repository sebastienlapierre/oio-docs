Puppet Manifest
===============

Here is an example manifest you can tune to your own settings:

- `OPENIO_PROXY_URL` should point to an oioproxy service. `6006` is the default port, so you can just change the `OIO_SERVER` to another server where OpenIO is installed.
- `admin_token` is used for KeyStone administrative purpose only, to secure your installation, modify it.
- To secure your installation, modify the password fields `SWIFT_PASS` and `DEMO_PASS`.

In a file called ``~/openio.pp``:

.. code-block:: puppet

   $openio_proxy_url = "http://OPENIO_PROXY_URL:6006"
   $admin_token = 'KEYSTONE_ADMIN_UUID'
   $swift_passwd = 'SWIFT_PASS'
   $admin_passwd = 'ADMIN_PASS'
   $demo_passwd = 'DEMO_PASS'

   # Deploy Openstack Keystone
   class { 'keystone':
     verbose             => True,
     admin_token         => $admin_token,
     database_connection => 'sqlite:////var/lib/keystone/keystone.db',
   }

   # Adds the admin credential to keystone.
   class { 'keystone::roles::admin':
     email    => 'test@openio.io',
     password => $admin_passwd,
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

   # Openstack Swift service credentials
   keystone_user { 'swift':
     ensure   => present,
     enabled  => True,
     password => $swift_passwd,
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

   # Demo account credentials
   keystone_tenant { 'demo':
     ensure  => present,
     enabled => True,
   }
   keystone_user { 'demo':
     ensure  => present,
     enabled => True,
     password => $demo_passwd,
   }
   keystone_role { '_member_':
     ensure => present,
   }
   keystone_user_role { 'demo@demo':
     roles  => ['admin','_member_'],
     ensure => present
   }

   # Deploy OpenIO Swift/S3 gateway
   class {'openiosds':}
   openiosds::namespace {'OPENIO':
       ns => 'OPENIO',
   }
   openiosds::oioswift {'oioswift-0':
     ns               => 'OPENIO',
     ipaddress        => '0.0.0.0',
     sds_proxy_url    => $openio_proxy_url,
     admin_password   => $swift_passwd,
     memcache_servers => "${ipaddress}:6019",
   }
   openiosds::memcached {'memcached-0':
     ns => 'OPENIO',
   }

.. note::

   The `demo` user will be created for testing purpose, following the example of the OpenStack Keystone documentation.


Package Installation and Service Configuration
==============================================

Now let's run Puppet, it install the packages and configure the services.
Apply the manifest:

   .. code-block:: console

      # sudo puppet apply --no-stringify_facts ~/openio.pp

This step may take a few minutes. Please be patient as it downloads and installs all necessary packages.
Once completed, all services will be installed and running using OpenIO GridInit init system.


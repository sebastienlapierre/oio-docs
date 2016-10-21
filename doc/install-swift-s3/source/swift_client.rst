============
Swift Client
============

Installation
~~~~~~~~~~~~

Install the OpenStack Swift Command Line Interface:

   .. only:: ubuntu or debian

      .. code-block:: console
     
         # apt-get install python-swiftclient

   .. only:: centos

      .. code-block:: console 

         # yum install python-swiftclient

You need to export these variables to use the Swift CLI. Create a file `keystonerc_demo` containing:

   .. code-block:: console

    export OS_TENANT_NAME=demo
    export OS_USERNAME=demo
    export OS_PASSWORD=DEMO_PASS
    export OS_AUTH_URL=http://localhost:5000/v2.0

Usage
~~~~~

Source the keystonerc file:

   .. code-block:: console

    # . keystonerc_demo

Create the account:

   .. code-block:: console

    # swift post

Swift client is enabled:

   .. code-block:: console

    # swift stat

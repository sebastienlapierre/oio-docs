====================
Openstack Swift APIs
====================

Swift CLI
=========

OpenStack Swift Client is installed inside the VM. Full documentation_ is available on the OpenStack_ website.

Connect to your VM and load the default account:

   .. code-block:: console

    # vagrant ssh

Load the provided Swift authentication file (in the homedir)

   .. code-block:: console

    # . keystonerc_demo

View the default account informations:

   .. code-block:: console

    # swift stat

Create a container in your account:

   .. code-block:: console

    # swift post my_container

List your files containers:

   .. code-block:: console

    # swift list

Upload a file in a container:

   .. code-block:: console

    # swift upload my_container /etc/magic

List your files in your container:

   .. code-block:: console

    # swift list my_container

Graphical User Interface (GUI)
==============================

Using the the OpenStack Swift HTTP profile_, CyberDuck_ can connect to your Swift proxy.

   + Insert your VM IP (provided at the end of your vagrant up)

   + Default Keystone port is 5000

   + Default username is demo:demo

   + You'll be asked for the password: DEMO_PASS


Cloud Drive
===========

You can use ExpanDrive_ to mount your OpenIO Object Storage on your Windows or Mac.

   + Select OpenStack Swift Storage

   + Server address is indicated at the end of install (default port is 5000): http://IP_ADDRESS:5000/v2.0

   + Username: demo

   + Tenant: demo

   + API Key: DEMO_PASS


.. _documentation: http://docs.openstack.org/cli-reference/content/swiftclient_commands.html
.. _OpenStack: http://docs.openstack.org
.. _profile: https://svn.cyberduck.io/trunk/profiles/Openstack%20Swift%20(HTTP).cyberduckprofile
.. _CyberDuck: http://cyberduck.io
.. _Expandrive: http://www.expandrive.com

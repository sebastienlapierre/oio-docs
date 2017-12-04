============
Installation
============

Setup the Ansible environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Download the `Ansible`_ profile for the OpenIO SDS Raspberry Pi cluster. This tarball contains Ansible files that will help you setup the environment locally. You will not modify your host global configuration to configure Ansible.
In a directory, download and uncompress the provided tarball:

   .. code-block:: shell

     # mkdir rpi_cluster
     # wget http://docs.openio.io/17.04/rpi_cluster.tar.gz
     # tar xf rpi_cluster.tar.gz

Now download the latest Ansible roles, this parts download locally the roles in the `roles/` sub-directory:

    .. code-block:: shell

      # cd ansible
      # ansible-galaxy install -p ./roles/ geerlingguy.ntp
      # ansible-galaxy install -p ./roles/ git+https://github.com/open-io/ansible-role-repo-openio-sds.git
      # ansible-galaxy install -p ./roles/ git+https://github.com/open-io/ansible-role-openio-sds.git

Adapt to your cluster
~~~~~~~~~~~~~~~~~~~~~

In the `inventory` file provided, modify the current hostnames to match yours or the hostnames you use to connect the Pis. In the following example, we suppose your Rapsberry Pi are named ``HOSTNAME1``, ``HOSTNAME2``, ``HOSTNAME3``.

    .. code-block:: shell

      # sed -i -e 's@rpi1@HOSTNAME1@g' -e 's@rpi2@HOSTNAME2@g' -e 's@rpi3@HOSTNAME3@g' inventory

You can check everythings alright with this command that must return you the hostnames. For the install, verify that hostnames are differents:

    .. code-block:: shell

      # ansible openio -a 'hostname'

If the command fails with ``/usr/bin/python: not found``, you can install it using:

    .. code-block:: shell

      # ansible-playbook playbooks/install_python.yml

Install OpenIO SDS
~~~~~~~~~~~~~~~~~~

To install your cluster, now run:

  .. code-block:: shell

    # ansible-playbook playbooks/site.yml

Ansible configures step-by-step the 3 Raspberry Pi and finishes on a summary of what happenned.
At the end of the run, your OpenIO SDS cluster is working, you can now start using it.


.. _Ansible: https://www.ansible.com/

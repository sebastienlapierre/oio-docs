=================================
Install Swift/S3 on Ubuntu Xenial
=================================

Initialize
==========

.. include:: initialize_debian.rst

Repositories Configuration
==========================

.. include:: packages_configuration_ubuntu.rst

.. include:: packages_configuration_debian.rst

3. Install the OpenStack repository

.. code-block:: console

   # TODO


Installation
============

We will use the OpenStack modules to install and configure OpenStack KeyStone.

Install the module:

.. code-block:: console

   # sudo puppet module install openstack-keystone

   # sudo sed -i "s@'upstart'@undef@" /etc/puppet/modules/keystone/manifests/params.pp

.. include:: deploy-swift-with-puppet.rst

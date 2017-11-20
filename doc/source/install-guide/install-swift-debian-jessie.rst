=================================
Install Swift/S3 on Debian Jessie
=================================

Initialize
==========

.. include:: initialize_debian.rst

Repositories Configuration
==========================

.. include:: packages_configuration_debian.rst

Installation
============

We will use the OpenStack modules to install and configure OpenStack KeyStone.

Install the module:

.. code-block:: console

   # sudo puppet module install openstack-keystone
   # sudo sed -i "s@'upstart'@undef@" /etc/puppet/modules/keystone/manifests/params.pp

.. include:: deploy-swift-with-puppet.rst

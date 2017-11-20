============================
Install Swift/S3 on Centos 7
============================

Initialize
==========

.. include:: initialize_centos.rst

Repositories Configuration
==========================

.. include:: packages_configuration_centos.rst

3. Install the OpenStack repository

.. code-block:: console

   # sudo yum -y install centos-release-openstack-pike


Installation
============

We will use the OpenStack modules to install and configure OpenStack KeyStone.

Install the module:

.. code-block:: console

   # sudo puppet module install openstack-keystone

.. include:: deploy-swift-with-puppet.rst

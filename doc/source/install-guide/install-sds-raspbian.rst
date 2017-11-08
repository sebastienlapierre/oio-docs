==============================
Install OpenIO SDS on Raspbian
==============================

Initialize
~~~~~~~~~~

.. include:: initialize_debian.rst


OpenIO Packages Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On each server:

1. Configure OpenIO SDS repository

  Install some tools to make the installation easier:

  .. code-block:: console

    # sudo apt-get -y install lsb-release apt-transport-https curl

  Add the repository configuration:

  .. code-block:: console

    # echo "deb http://mirror.openio.io/pub/repo/openio/sds/17.04/$(lsb_release -i -s)/ $(lsb_release -c -s)/" | sudo tee /etc/apt/sources.list.d/openio-sds.list

  Add the OpenIO archive key:

  .. code-block:: console

    # curl http://mirror.openio.io/pub/repo/openio/APT-GPG-KEY-OPENIO-0 | sudo apt-key add -

2. Install the OpenIO puppet module:

  .. code-block:: console

    # sudo apt-get update; sudo apt-get install puppet-module-openio-openiosds -y

.. include:: deploy-sds-with-puppet.rst

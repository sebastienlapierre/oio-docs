On each server:

1. Configure OpenIO SDS repository

  Add the Debian Backports_ repository:

  .. code-block:: console

    # echo "deb http://httpredir.debian.org/debian $(lsb_release -c -s)-backports main contrib non-free" | sudo tee /etc/apt/sources.list.d/debian-backports.list

  Add the OpenIO SDS repository configuration:

  .. code-block:: console

    # echo "deb http://mirror.openio.io/pub/repo/openio/sds/17.04/$(lsb_release -i -s)/ $(lsb_release -c -s)/" | sudo tee /etc/apt/sources.list.d/openio-sds.list

  Install cURL if necessary:

  .. code-block:: console

    # sudo apt-get install curl -y

  Add the OpenIO archive key to verify packages signatures:

  .. code-block:: console
 
    # curl http://mirror.openio.io/pub/repo/openio/APT-GPG-KEY-OPENIO-0 | sudo apt-key add -

2. Install OpenIO SDS puppet module:

  .. code-block:: console

    # sudo apt-get update; sudo apt-get install puppet-module-openio-openiosds -y

.. _Backports: https://wiki.debian.org/Backports

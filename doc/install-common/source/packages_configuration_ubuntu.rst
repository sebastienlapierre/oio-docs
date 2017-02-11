On each server:

1. Install OpenIO SDS repository package

  Add the repository configuration:

  .. code-block:: console

    # echo "deb http://mirror.openio.io/pub/repo/openio/sds/16.10/$(lsb_release -i -s)/ $(lsb_release -c -s)/" | sudo tee /etc/apt/sources.list.d/openio-sds.list

  Install cURL if necessary:

    # sudo apt-get install curl -y

  Add the OpenIO archive key:

  .. code-block:: console
 
    # curl http://mirror.openio.io/pub/repo/openio/APT-GPG-KEY-OPENIO-0 | sudo apt-key add -

2. Install OpenIO puppet module:

  .. code-block:: console

    # sudo apt-get update; sudo apt-get install puppet-module-openio-openiosds -y


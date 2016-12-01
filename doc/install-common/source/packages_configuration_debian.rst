On each server:

1. Install OpenIO repository package

  We provide a shell script (relying on Puppet) that allows you to install easily a namespace named *OPENIO*

  Add the repository configuration:

  .. code-block:: console

    # echo "deb http://mirror.openio.io/pub/repo/openio/sds/16.10/$(lsb_release -i -s)/ $(lsb_release -c -s)/" | sudo tee /etc/apt/sources.list.d/openio-sds.list

  Add the OpenIO archive key:

  .. code-block:: console
 
    # curl http://mirror.openio.io/pub/repo/openio/APT-GPG-KEY-OPENIO-0 | apt-key add -

2. Install OpenIO puppet module:

  .. code-block:: console

    # apt-get update; apt-get install puppet-module-openio-openiosds -y


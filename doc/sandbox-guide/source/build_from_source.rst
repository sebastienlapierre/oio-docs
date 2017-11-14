=================
Build From Source
=================

This sections describes how to compile OpenIO SDS from the official source fetched from GitHub.

The build procedure is available for:

* Ubuntu 16.04

Setup the $SDS variable
-----------------------

Throughout this guide, the environment variable `SDS` will be used several times. You should ensure this variable is always defined.
It should be set to the name of directory where you will be building OpenIO SDS.

   .. code-block:: shell

      export SDS=$HOME/local


Repository Configuration
------------------------
We provide easy access to build and runtime dependencies versions not available in common distributions.

   .. code-block:: shell

      echo "deb http://mirror.openio.io/pub/repo/openio/sds/17.04/Ubuntu/ xenial/" | sudo tee /etc/apt/sources.list.d/openio-sds.list
      curl http://mirror.openio.io/pub/repo/openio/APT-GPG-KEY-OPENIO-0 | sudo apt-key add -
      sudo apt-get -y update


Build Dependencies
------------------

Build tools

   .. code-block:: shell

      sudo apt-get -y install git cmake

Build dependencies

   .. code-block:: shell

      sudo apt-get -y install \
          flex bison \
          libcurl4-gnutls-dev \
          libglib2.0-dev \
          libapreq2-dev \
          libsqlite3-dev \
          libjson-c-dev \
          apache2 \
          apache2-dev \
          liblzo2-dev \
          libzmq3-dev \
          libattr1-dev \
          libzookeeper-mt-dev \
          openio-asn1c \
          openio-gridinit \
          liberasurecode-dev \
          python-dev \
          python-pbr \
          python-setuptools \
          libleveldb-dev

Fetch Source
------------

Official OpenIO SDS source is available from Github.

   .. code-block:: shell

      git clone https://github.com/open-io/oio-sds.git


Build
-----

We perform build in a separate folder from sources.

   .. code-block:: shell

      mkdir build && cd build
      cmake \
          -DCMAKE_INSTALL_PREFIX=${SDS} \
          -DLD_LIBDIR=lib \
          -DAPACHE2_MODDIR=${SDS}/lib/apache2 \
          -DAPACHE2_LIBDIR=/usr/lib/apache2 \
          -DAPACHE2_INCDIR=/usr/include/apache2 \
          ../oio-sds
      make

Install
-------

   .. code-block:: shell

      make install
      ( cd ../oio-sds && python setup.py install --user --install-scripts=${SDS}/bin)

Binaries and scripts are installed in ``$SDS/bin``. Libraries are installed in ``$SDS/lib``.
Note that for Python, output is in local user installation ``$HOME/.local/``.

=============
Sandbox Setup
=============


Environment
-----------

We need to setup a few environment variables so everything we built previously is correctly found and used.

   .. code-block:: shell

      echo "export PATH=${PATH}:$SDS/bin" >> $HOME/.bashrc
      echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SDS/lib" >> $HOME/.bashrc
      source $HOME/.bashrc


Runtime Dependencies
--------------------

To run the sandbox, we need additional runtime dependencies:

External services:

* Redis: advanced key-value store used by Account services

* Beanstalkd: simple and fast work queue used by OpenIO to run background jobs

Libraries:

* Python dependencies: several services and tools in OpenIO are built with Python


   .. code-block:: shell

      sudo apt-get install -y
          python-cliff \
          python-eventlet \
          python-gunicorn \
          python-plyvel \
          python-redis \
          python-requests \
          python-werkzeug \
          python-xattr \
          python-yaml \
          python-zookeeper \
          redis-server \
          beanstalkd


Enable external services

   .. code-block:: shell

      sudo systemctl enable beanstalkd

We used to start redis from systemctl, but an instance will be started along with
OpenIO SDS services.

Create Sandbox
--------------

   .. code-block:: shell

      oio-reset.sh -f etc/bootstrap-preset-MINIMAL.yml

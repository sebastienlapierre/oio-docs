============================
OpenIO Official Docker Image
============================

========
Abstract
========

This `Docker <http://www.docker.com>`_ image provides an easy way to run an OPENIO namespace.
It deploys and configure a simple non-replicated namespace in a single container.

OpenIO SDS service discovering and resolution relies on IPs, meaning that you can't change service IPs after they have been registered to the cluster. By default, Docker networking may change you IP when you container restarts which is not compatible with OpenIO SDS at the moment.

======
Deploy
======

First, pull the `OpenIO Docker image <https://hub.docker.com/r/openio/sds/>`_ from the `Docker Hub <https://hub.docker.com>`_:

   .. code-block:: console

    # docker pull openio/sds

By default, start a simple namespace listening on 127.0.0.1 inside the container using docker run:

   .. code-block:: console

    # docker run -ti --tty openio/sds

============================
Using host network interface
============================

You can start an instance using `Docker host mode networking <https://docs.docker.com/engine/reference/run/#network-host>`_, it allows you to access the services outside your container. You can specify the interface or the IP you want to use.


Setting the interface:

   .. code-block:: console

    # docker run -ti --tty -e OPENIO_IFDEV=enp0s8 --net=host openio/sds

Specifying the IP:

   .. code-block:: console

    # docker run -ti --tty -e OPENIO_IPADDR=192.168.56.101 --net=host openio/sds

===========================
Deploy the S3/Swift gateway
===========================

You can launch the OpenIO docker image with our S3 and Swift gateway embedded, and map its port (6007) to access to it remotely:

Launching the container with the port mapping:

   .. code-block:: console

    # docker run -ti --tty -p 127.0.0.1:6007:6007 openio/sds

The S3 and Swift gateway is now accessible on `127.0.0.1:6007`.

You can use the swift APIs:

   .. code-block:: console

    # swift -A http://127.0.0.1:6007/auth/v1.0/ -U demo:demo -K DEMO_PASS stat

Or the S3 APIs with the aws CLI.
First set your credentials in the following configuration file `~/.aws/credentials`:

   .. code-block:: console

    # [default]
    aws_access_key_id=demo:demo
    aws_secret_access_key=DEMO_PASS

Finally you can pu your first object:

   .. code-block:: console

    # aws --endpoint-url http://127.0.0.1:6007 --no-verify-ssl s3 cp /etc/localtime s3://bucket1

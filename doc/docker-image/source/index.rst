============================
OpenIO Official Docker Image
============================

========
Abstract
========

This image provides an easy way to run an OPENIO namespace.
It deploys and configure a simple non-replicated namespace in a single container.

OpenIO SDS service discovering and resolution relies on IPs, meaning that you can't change service IPs after they have been registered to the cluster. By default, Docker networking may change you IP when you container restarts which is not compatible with OpenIO SDS at the moment.

======
Deploy
======

First, pull the OpenIO docker image from the Docker Hub:

   .. code-block:: console

    # docker pull openio/sds

By default, start a simple namespace listening on 127.0.0.1 inside the container using docker run:

   .. code-block:: console

    # docker run -ti --tty openio/sds

============================
Using host network interface
============================

You can start an instance using Docker host mode networking, it allows you to access the services outside your container. You can specify the interface or the IP you want to use.


Setting the interface:

   .. code-block:: console

    # docker run -ti --tty -e OPENIO_IFDEV=enp0s8 --net=host openio/sds

Specifying the IP:

   .. code-block:: console

    # docker run -ti --tty -e OPENIO_IPADDR=192.168.56.101 --net=host openio/sds


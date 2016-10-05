============================
Using host network interface
============================

You can start an instance using Docker host mode networking, it allows you to access the services outside your container. You cant specify the interface or the IP you want to use.


Setting the interface:

   .. code-block:: console

    # docker run -ti --tty -e OPENIO_IFDEV=enp0s8 --net=host openio/sds

Specifying the IP:

   .. code-block:: console

    # docker run -ti --tty -e OPENIO_IPADDR=192.168.56.101 --net=host openio/sds

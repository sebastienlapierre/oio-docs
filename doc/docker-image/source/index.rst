=======================================
OpenIO Command-Line Interface Reference
=======================================

Abstract
~~~~~~~~

This image provides an easy way to run an OPENIO namespace.
It deploys and configure a simple non-replicated namespace in a single container.

OpenIO SDS depends on IPs, meaning that you can't change service IPs after they have been registered to the cluster. By default, Docker networking change you IP when you container restarts which is not compatible with OpenIO SDS at the moment.

Contents
~~~~~~~~

.. toctree::
   :maxdepth: 1

   deploy
   network_interface


.. end of contents

Search in this guide
~~~~~~~~~~~~~~~~~~~~

* :ref:`search`

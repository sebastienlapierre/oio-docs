=============
Prerequisites
=============

Hardware
^^^^^^^^
- RAM: 2GB recommended

Operating system
^^^^^^^^^^^^^^^^
.. only:: centos

   - CentOS 7

.. only:: debian

   - Debian 8 (Jessie)

.. only:: ubuntu

   - Ubuntu 16.04 (Xenial)

.. only:: raspbian

   - Raspbian 8 (Jessie)

Network
^^^^^^^
- All nodes connected to the same LAN through the specified interface (first one by default)
- Firewall is disabled
- SELinux or AppArmor are disabled

System
^^^^^^
- root privileges are required (using sudo)
- All nodes must have different hostnames
- /var/lib partition must support `Extended Attributes`_: XFS is recommended

.. _Extended Attributes: https://en.wikipedia.org/wiki/Extended_file_attributes#Linux


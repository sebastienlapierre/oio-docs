==================
Release management
==================

Version numbers
---------------

Each OpenIO subproject (oio-sds_, oiopy_...) has its own version number.
We will follow the rules defined in `openstack's fork of Semantic Versioning`_.
Breaking changes will increment the major version number,
regular changes will increment the minor version number,
and bug fixes will increment the patch version number.

A branch in the source code repository should be created for each long-term
supported version, named like *release-X.Y*, with X an Y being the major
and minor version numbers.

OpenIO distributions (aka software suites)
------------------------------------------

From time to time, we will release a **distribution** in the form
of a package repository (RPM and DEB) containing coherent versions of all
subprojects. These distributions will be named after the year and
the month they are released (e.g. 16.04 for April 2016), as does Ubuntu.
During its life, a distribution will receive only non-breaking updates
of its subprojects.

.. _oio-sds: https://github.com/open-io/oio-sds
.. _oiopy: https://github.com/open-io/oiopy
.. _openstack's fork of Semantic Versioning: http://docs.openstack.org/developer/pbr/semver.html


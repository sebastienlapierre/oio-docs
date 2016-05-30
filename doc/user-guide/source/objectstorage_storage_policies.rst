================
Storage Policies
================

Storage Policies are the way to describe different storage tiers in your storage platform.

A Storage Policy is defined by a Storage Class and a Data Security.

They are defined at the Namespace level and you configure a default Storage Policy.


Example of a full Storage Policy configuration:

   .. code-block:: text

      [STORAGE_POLICY]
      VIDEO=GOLD:EC_6_3
      MAIL=SILVER:REPLI_3
      DEFAULT=NONE:REPLI_2

      [STORAGE_CLASS]
      GOLD=SILVER,NONE
      SILVER=NONE

      [DATA_SECURITY]
      REPLI_3=plain/nb_copy=3,distance=1
      REPLI_2=plain/nb_copy=2,distance=1
      EC_6_3=ec/algo=isa_l_rs_vand,k=6,m=3,distance=1

.. note::
   You can name your storage policy as you like.

Storage Class
-------------

The Storage Class is a convenient way to mix different kind of storage hardware and manage them depending of their performance, cost, etc.

Example of a Storage Class configuration:

   .. code-block:: text

      [STORAGE_CLASS]
      GOLD=SILVER,NONE
      SILVER=NONE

.. note::

   Note that when you define a Storage Class you can select fallback classes. Example: ``GOLD=SILVER,NONE`` defines a fallback on the ``SILVER`` for the ``GOLD`` Storage Class.


.. note::
   You can name your storage class as you like.


Data Security
-------------

The Data Security describes the way an object is stored on the storage pool.

You can choose between two security types:

* ``plain`` replication security

* ``ec`` erasure coding security

In the replication security, chunks are replicated at a configurable level.

In the erasure coding security, chunks are split into data chunks and parity chunks.

Example of a Data Security configuration:

   .. code-block:: text

      [DATA_SECURITY]
      REPLI_3=plain/nb_copy=3,distance=1
      REPLI_2=plain/nb_copy=2,distance=1
      EC_6_3=ec/algo=isa_l_rs_vand,k=6,m=3,distance=1

.. note::
   You can name your data security as you like.


.. list-table:: Options
   :header-rows: 1

   * - Option
     - Description
   * - ``nb_copy``
     - replication only: defines the number of copy to store
   * - ``distance``
     - defines the minimum distance between chunks to ensure security
   * - ``algo``
     - erasure coding only: defines the erasure coding algorithm to use
   * - ``k``
     - erasure coding only: defines the number of data chunks
   * - ``m``
     - erasure coding only: defines the number of parity chunks


Find more details in the `Erasure Coding`_ section.

.. _`Erasure Coding`: ./objectstorage_ec.html

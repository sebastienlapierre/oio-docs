==============
Erasure coding
==============

Erasure coding uses a set of algorithms (similar to RAID 6) to allow the recovery
of missing data using a subset of original data.
In theory, EC techniques uses less storage capacity than standard replication,
but keeping the same durability guarantees.
Erasure coding is transparent from the application perspective.

To use erasure coding, you must have a storage policy with an EC Data Security configured.

Example of erasure coding storage policy:

   .. code-block:: text

      [STORAGE_POLICY]
      EC=NONE:EC:NONE
      [DATA_SECURITY]
      EC=RAIN:k=6|m=2|algo=liber8tion|distance=1

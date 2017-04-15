========================
Configure a rawx service
========================

Preparation
~~~~~~~~~~~

If you have several disks on the same node, or you want to add a new disk on an existing node, you will need to deploy one rawx service per mount point, and specify the targeted directory for each.

We are assuming that your disks are already formatted (xfs) and mounted.

Configuration
~~~~~~~~~~~~~

For each mount point, you will have to add/append this 3 blocks in your puppet file.

- Replace ``MYNAMESPACE`` with the name of your namespace
- Replace ``ID`` with an unused UID in your puppet file
- Replace ``port`` in the rawx block and in the rdir block with unused ones on your server
- Replace ``documentRoot`` in the rawx block and ``volume`` in the oioblobindexer block with the targeted folder

  .. code-block:: puppet

     openiosds::rawx {'rawx-UID':
       ns        => 'MYNAMESPACE',
       ipaddress => $ipaddress,
       num => 'UID',
       port => '6050'
       documentRoot => '/mnt/disk1',
     }
     openiosds::rdir {'rdir-UID':
       ns        => 'MYNAMESPACE',
       ipaddress => $ipaddress,
       num => 'UID',
       port => '6650'
     }
     openiosds::oioblobindexer { 'oio-blob-indexer-rawx-UID':
       num => 'UID',
       ns      => 'MYNAMESPACE',
       volume => '/mnt/disk1',
     }

You can add this three blocks configuration as many times as needed (one per disk).

Service configuration
~~~~~~~~~~~~~~~~~~~~~

Using puppet, we will configure the rawx services.
Apply the manifest:

   .. code-block:: console

      # sudo puppet apply --no-stringify_facts /root/openio.pp


Finally, unlock all services in the namespace to enable your new services:

   .. code-block:: console

      # openio --oio-ns=MYNAMESPACE cluster unlockall

Be sure that every score is greater that 0 using `openio cluster list`:

   .. code-block:: console

      # openio --oio-ns MYNAMESPACE cluster list rawx



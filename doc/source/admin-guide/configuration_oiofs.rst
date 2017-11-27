========================================
Configure an OpenIO Filesystem connector
========================================

Description
~~~~~~~~~~~

OpenIO proposes a FUSE implementation to connect an OpenIO SDS namespace as
backend for a file system.

Prerequisites
~~~~~~~~~~~~~

In this guide we suppose you have an OpenIO SDS namespace that is ready to use,
in version **{{OIO_SDS_BRANCHNAME}}**, and then an oio-fs connector in version
**{{OIO_FS_BRANCHNAME}}**.

Its name is **OPENIO** and it is accessible through an `oio-proxy` at
**127.0.0.1:6000**.

If you do not have such an installation, please refer to the guide
":ref:`label-intall-guide`" for a production-grade installation, or to the
guide ":ref:`label-sandbox-guide`" for an installation "the hard way" (with
all the control you might dream of).


oio-fs configuration
~~~~~~~~~~~~~~~~~~~~

Prepare your system
^^^^^^^^^^^^^^^^^^^

If working with a regular "non-priviledged" user, you will need to configure
the FUSE permissions. In the file `/et/fuse.conf`, you should uncomment the
line with `user_allow_other`.

If working in a container, be sure it has been started in proviledged mode.
Please contact your system administrator if this is not the case, or to check
if it is.


Prepare oio-sds
^^^^^^^^^^^^^^^

To start working with an oio-fs mount point, you need to create the directory
reference that will gather all the container shards that hold the inodes of
your file system.

.. code-block:: console
   :caption: Init oio-sds for a oio-fs usage

   $ mkfs.oiofs OPENIO/MyAccount/MyReference


This former command will create a directory reference and associate several
properties to it. These properties are really important, and they should not
change during the lifetime of the oio-fs volume.

.. code-block:: console
   :caption: Check the result

   $ openio --oio-ns OPENIO --oio-account MyAccount reference show MyReference
   +---------------------------------+-------------+
   | Field                           | Value       |
   +---------------------------------+-------------+
   | account                         | MyAccount   |
   | meta.oiofs_chunk_size           | 1048576     |
   | meta.oiofs_inodes_per_container | 65536       |
   | name                            | MyReference |
   +---------------------------------+-------------+


oiofs-fuse: CLI options
^^^^^^^^^^^^^^^^^^^^^^^

Let's study the `oiofs-fuse` command before starting it.
Many options are available:

.. code-block:: console
   :caption: oiofs-fuse help section

   # oiofs-fuse --help
   usage: oiofs-fuse [oio] mountpoint [options]

   general options:
     -o opt,[opt...]        mount options
     -h   --help            print help
     -V   --version         print version

   OIOFS options:
     -v   --verbose              be verbose
     --syslog-id <id>            set syslog id
     --oiofs-files-per-folder    set the maximum number of files
                                 per cache subfolder
     --oiofs-config              configuration file
     --oiofs-user-url <url>      set oiofs target user URL

   FUSE options:
     -d   -o debug          enable debug output (implies -f)
     -f                     foreground operation
     -s                     disable multi-threaded operation

     -o allow_other         allow access to other users
     -o allow_root          allow access to root
     -o auto_unmount        auto unmount on process termination
     -o nonempty            allow mounts over non-empty file/dir
     -o default_permissions enable permission checking by kernel
     -o fsname=NAME         set filesystem name
     -o subtype=NAME        set filesystem type
     -o large_read          issue large read requests (2.4 only)
     -o max_read=N          set maximum size of read requests
     -o max_write=N         set maximum size of write requests
     -o max_readahead=N     set maximum readahead
     -o max_background=N    set number of maximum background requests
     -o congestion_threshold=N  set kernel's congestion threshold
     -o async_read          perform reads asynchronously (default)
     -o sync_read           perform reads synchronously
     -o atomic_o_trunc      enable atomic open+truncate support
     -o big_writes          enable larger than 4kB writes
     -o no_remote_lock      disable remote file locking
     -o no_remote_flock     disable remote file locking (BSD)
     -o no_remote_posix_lock disable remove file locking (POSIX)
     -o [no_]splice_write   use splice to write to the fuse device
     -o [no_]splice_move    move data while splicing to the fuse device
     -o [no_]splice_read    use splice to read from the fuse device


The only mandatory value is `--oiofs-user-url` that must match the oio-sds URL
you already used earlier: `OPENIO/MyAccount/MyReference`.


oiofs-fuse: config. file
^^^^^^^^^^^^^^^^^^^^^^^^

The minimal file you need to provides must contain the 3 keys that a presented
below:

.. code-block:: json
   :caption: Minimal configuration

   {
     "redis_server": "127.0.0.1:6379",
     "cache_directory": "/run/user/1000/oiofs-cache",
     "cache_size": "5000000"
   }

But several other keys are possible, and a complete example is presented below:

.. code-block:: json
   :caption: Complete configuration

   {
     "stats_server": "127.0.0.1:8080",
     "redis_server": "127.0.0.1:6379",
     "redis_sentinel_server": "127.0.0.1:6378",
     "redis_sentinel_name": "plop",
     "cache_directory": "/run/user/1000/oiofs-cache",
     "cache_size": "5000000",
     "cache_asynchronous": true
   }


stats_server
------------

The adress of the internal HTTP server that exhibit some metrics about the behavior
of the current oiofs-fuse.

* **optional**
* Format: dot-decimal representation of an IPv4 address or a colon-hexadecimal representation of an IPv6 address, followed by a colon the the TCP port.
* Default: None


redis_server
------------

The adress of the Redis that manage the inodes persistence.

* **MANDATORY**
* Format: dot-decimal representation of an IPv4 address or a colon-hexadecimal representation of an IPv6 address, followed by a colon the the TCP port.
* Default: None


redis_sentinel_name
-------------------

The name of the redis sentinel, to be used in conjunction with *redis_sentinel_server*

* **optional**
* Format: an ASCII string with no space.
* Default: None


redis_sentinel_server
---------------------

The address of the redis sentinel, to be used in conjunction with *redis_sentinel_name*

* **optional**
* Format: dot-decimal representation of an IPv4 address or a colon-hexadecimal representation of an IPv6 address, followed by a colon the the TCP port.
* Default: None

cache_directory
---------------

Explain where oiofs-fuse will will store its cached chunks of data.
It must point to a directory with read / write / execute permissions granted
to the user running oiofs-fuse.

No special options is required, but the operator is invited to dedicate a
directory on a partitio that is rather fast. The fastest the best!
`tmpfs` caches show good results.

* **MANDATORY**
* Format: the path to an accessible directory
* Default: None


cache_size
----------

How many bytes might a cache hold?
When the limit is reached, the behavior is different depending on the type
of cache that has been configured.

In cases of a synchronous cache (when `cache_asynchronous` is set to `false`),
the content is expunged from the cache until enough space is recovered for
the file being accessed. But in cases of an asynchronous cache, reaching the
is a possible trigger for a write-back of the cache.

* **MANDATORY**
* Format: an ASCII string with no space.
* Default: None


cache_asynchronous
------------------

* **optional**
* Format: an ASCII string with no space.
* Default: *false*


Additional notes
~~~~~~~~~~~~~~~~

Fast setups
^^^^^^^^^^^

Conservative setups
^^^^^^^^^^^^^^^^^^^


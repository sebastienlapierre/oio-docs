Container management
====================

Create a container
------------------

   .. code-block:: console

    # openio container create my_container

    +--------------+---------+
    | Name         | Created |
    +--------------+---------+
    | my_container | True    |
    +--------------+---------+

Information about container
---------------------------

Display information about this container.

   .. code-block:: console

    # openio container show my_container

    +-------------+--------------------------------------------------------------------+
    | Field       | Value                                                              |
    +-------------+--------------------------------------------------------------------+
    | account     | my_account                                                         |
    | base_name   | CB2D04216603B8274AB831F889EAA4B2656D1EBA45B658712D59C77DAC86E08A.1 |
    | bytes_usage | 0                                                                  |
    | container   | my_container                                                       |
    | ctime       | 1441105114                                                         |
    +-------------+--------------------------------------------------------------------+

Container properties
--------------------

To set a property <key=value> to a given container:

   .. code-block:: console

    # openio container set mu_container --property color=blue

Properties can be displayed with ``container show``:

   .. code-block:: console

    # openio container show my_container

    +-----------------+--------------------------------------------------------------------+
    | Field           | Value                                                              |
    +-----------------+--------------------------------------------------------------------+
    ...
    | meta.color      | blue                                                               |
    +-----------------+--------------------------------------------------------------------+

To delete a property:

   .. code-block:: console

    # openio container unset my_container --property color

Object management
=================

Create object
-------------

   .. code-block:: console

    # echo 'Hello OpenIO!' > test.txt
    # openio object create my_container test.txt

    +----------+------+----------------------------------+
    | Name     | Size | Hash                             |
    +----------+------+----------------------------------+
    | test.txt |   14 | 9EB03B6E836CEAE565BA79F76C821DDA |
    +----------+------+----------------------------------+

List objects
------------

   .. code-block:: console

    # openio object list my_container

    +----------+------+----------------------------------+
    | Name     | Size | Hash                             |
    +----------+------+----------------------------------+
    | test.txt |   14 | 9EB03B6E836CEAE565BA79F76C821DDA |
    +----------+------+----------------------------------+

Containers can hold a large number of objects so there are several methods to
filter the results.

Here are the optional arguments which can be used:

- ``--marker`` : Indicates where to start the listing from.
- ``--end_marker`` : Indicates where to stop the listing.
- ``--prefix`` : If set, the listing only includes objects whose name begin with its value.
- ``--delimiter`` : If set, excludes the objects whose name contains its value.
  Only takes a single character. It can also be combined with the ``--prefix`` for advanced listings.
- ``--limit`` : Indicates the maximum number of objects to return in the listing.

To illustrate these features, create those files and store them in a container

   .. code-block:: console

    # touch folder_1 folder_2 folder_3_0 file1 file2 config1 config2
    # openio object create my_container folder_1 folder_2 folder_3_0 file1 file2 config1 config2
    [...]

To list all the objects :

   .. code-block:: console

    # openio object list my_container

    +------------+------+----------------------------------+
    | Name       | Size | Hash                             |
    +------------+------+----------------------------------+
    | config1    |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | config2    |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | file1      |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | file2      |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | folder_1   |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | folder_2   |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | folder_3_0 |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | test.txt   |   14 | 9EB03B6E836CEAE565BA79F76C821DDA |
    +------------+------+----------------------------------+

Let's use the filtering features:

This only outputs a maximum of three objects whose names are lexically greater than ``e``:

   .. code-block:: console

    # openio object list my_container --limit 3 --marker e

    +----------+------+----------------------------------+
    | Name     | Size | Hash                             |
    +----------+------+----------------------------------+
    | file1    |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | file2    |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | folder_1 |    0 | D41D8CD98F00B204E9800998ECF8427E |
    +----------+------+----------------------------------+

This only outputs the objects whose names begin with ``file``:

   .. code-block:: console

    # openio object list my_container --prefix file

    +-------+------+----------------------------------+
    | Name  | Size | Hash                             |
    +-------+------+----------------------------------+
    | file1 |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | file2 |    0 | D41D8CD98F00B204E9800998ECF8427E |
    +-------+------+----------------------------------+

This excludes all the objects whose names contain a ``_`` character:

   .. code-block:: console

    # openio object list my_container --delimiter _

    +----------+------+----------------------------------+
    | Name     | Size | Hash                             |
    +----------+------+----------------------------------+
    | config1  |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | config2  |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | file1    |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | file2    |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | test.txt |   14 | 9EB03B6E836CEAE565BA79F76C821DDA |
    +----------+------+----------------------------------+

This collects all the objects whose names begin with ``folder_``
and then excludes all those whose names contain a ``_`` character after the prefix:

   .. code-block:: console

    # openio object list my_container --prefix folder_ --delimiter _

    +----------+------+----------------------------------+
    | Name     | Size | Hash                             |
    +----------+------+----------------------------------+
    | folder_1 |    0 | D41D8CD98F00B204E9800998ECF8427E |
    | folder_2 |    0 | D41D8CD98F00B204E9800998ECF8427E |
    +----------+------+----------------------------------+

Note that this can be used to emulate a hierarchy with directories.

Save object
-----------

Saves the data stored in the given object to the ``--file`` destination :

   .. code-block:: console

    # openio object save my_container test.txt --file /tmp/test.txt

If the destination file already exists, its content will be deleted and replaced with this new one.

You can also save all the objects from a container to your working directory in a single command:

   .. code-block:: console

    # mkdir test_folder && cd test_folder
    # openio container save my_container
    # ls

    config1  config2  file1  file2  folder_1  folder_2  folder_3_0  test.txt

    # cd .. && rm -rf test_folder

Information about object
------------------------

Display the informations about an object:

   .. code-block:: console

    # openio object show my_container test.txt

    +-----------+----------------------------------+
    | Field     | Value                            |
    +-----------+----------------------------------+
    | account   | my_account                       |
    | container | my_container                     |
    | ctime     | 1441057689                       |
    | hash      | 9EB03B6E836CEAE565BA79F76C821DDA |
    | mime-type | octet/stream                     |
    | object    | test.txt                         |
    | policy    | none                             |
    | size      | 14                               |
    +-----------+----------------------------------+

Object properties
-----------------

To set a property <key=value> to a given object:

   .. code-block:: console

    # openio object set my_container test.txt --property size=small

Properties can be displayed with ``object show``:

   .. code-block:: console

    # openio object show my_container test.txt

    +-----------+----------------------------------+
    | Field     | Value                            |
    +-----------+----------------------------------+
    [...]
    | meta.size | small                            |
    [...]
    +-----------+----------------------------------+

To delete a property:

   .. code-block:: console

    # openio object unset my_container test.txt --property size

Delete object
-------------

   .. code-block:: console

    # openio object delete my_container test.txt

Delete container
----------------

   .. code-block:: console

    # openio container delete my_container

Note : It is not possible to delete a non empty container.

   .. code-block:: console

    Request error: Container not empty (HTTP 409) (STATUS 438)

There are still objects in the container.

First to delete all objects stored in the container.

   .. code-block:: console

    # openio object delete my_container folder_3_0 folder_2 folder_1 file2 file1 config2 config1

And finally delete the container.

   .. code-block:: console

    # openio container delete my_container

Account management
==================

Accounts track usage about storage, they are automatically created.

Information about account
-------------------------

  To show informations about an account: number of containers, number of objects and total storage usage.

   .. code-block:: console

    # openio account show my_account

    +------------+------------------+
    | Field      | Value            |
    +------------+------------------+
    | bytes      | 0                |
    | containers | 1                |
    | ctime      | 1441108158.46772 |
    | id         | my_account       |
    | metadata   | {}               |
    | objects    | 0                |
    +------------+------------------+


Use multiple accounts
---------------------

Specify in which account to execute the actions by adding the
``--oio-account <account_name>`` parameter to your commands:

   .. code-block:: console

    # openio container create my_container --oio-account my_account_2

    +----------------+---------+
    | Name           | Created |
    +----------------+---------+
    | my_container   | True    |
    +----------------+---------+

The account ``my_account_2`` was automatically created.

   .. code-block:: console

    # openio container list --oio-account my_account_2

    +----------------+-------+-------+
    | Name           | Bytes | Count |
    +----------------+-------+-------+
    | test_container |     0 |     0 |
    +----------------+-------+-------+


You can also create manually an account:

   .. code-block:: console

    # openio account create my_account_3

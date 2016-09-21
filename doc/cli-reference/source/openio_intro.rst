Using the command line
======================

To list available commands run ``openio help``:

   .. code-block:: console

    # openio help

    usage: openio [--version] [-v | -q] [--log-file LOG_FILE] [-h] [--debug]
                  [--oio-ns <namespace>] [--oio-account <account>]
                  [--oio-proxyd-url <proxyd url>] [--admin]

    Command-line interface to the OpenIO APIs

    optional arguments:
      --version             show program's version number and exit
      -v, --verbose         Increase verbosity of output. Can be repeated.
      -q, --quiet           Suppress output except warnings and errors.
      --log-file LOG_FILE   Specify a file to log output. Disabled by default.
      -h, --help            Show help message and exit.
      --debug               Show tracebacks on errors.
      --oio-ns <namespace>  Namespace name (Env: OIO_NS)
      --oio-account <account>
                            Account name (Env: OIO_ACCOUNT)
      --oio-proxyd-url <proxyd url>
                            Proxyd URL (Env: OIO_PROXYD_URL)
      --admin               passing commands into admin mode

    Commands:
    [...]

Help on specific command
------------------------

To get help on any command, use the ``help`` command.

   .. code-block:: console

    # openio help container create

    usage : openio container create [-h] [-f {csv,html,json,table,value,yaml}]
                   [-c COLUMN] [--max-width <integer>]
                   [--quote {all,minimal,none,nonnumeric}]
                   <container-name> [<container-name> ...]

    Create container

    positional arguments:
    <container-name>      New container name(s)
    [...]


Get started
-----------

To use the CLI we need to indicate the namespace name:

   .. code-block:: console

    # export OIO_NS=OPENIO

Most storage operations also need an account name:

   .. code-block:: console

    # export OIO_ACCOUNT=my_account

Note here that we use environment variables but we could also use the
command-line arguments ``--oio-ns`` and ``--oio-account``.


Environment variables
---------------------

The following environment variables are accepted by the `openio` command

* ``OIO_NS`` The namespace name.
* ``OIO_ACCOUNT`` The account name to use.
* ``OIO_PROXYD_URL`` Proxyd URL to connect to.

Configuration files
-------------------

By default, the ``openio`` command line looks for its configuration in
``/etc/oio/sds`` and in the directory ``.oio`` within your ``$HOME``.

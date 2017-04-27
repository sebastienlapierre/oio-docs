==========
Log Format
==========

The services in an OpenIO system respect a common format for their logs. Each
log item is a single line of text, encoded in UTF-8. A line is a sequence of
items separated by a sequence of white spaces. For an easy parsing, the variety
of the messages is organized around a recursion of envelopes (header and
payload). All the fields are always present on a line, and when a field is not
valuated it is represented by a single dash character.


COMMON envelope
~~~~~~~~~~~~~~~

All the messages share this envelope. The first 3 fiellds depend on syslog,
and all the others are populated by the application.

.. list-table:: Common Header
   :widths: 20 100

   * - Timestamp
     - When the message has been issued. Should be displayed in ISO-8601
   * - Hostname
     - Where (on the platform) was the log trace emitted
   * - Instance ID
     - Logical identifier of the runninng application
   * - Process ID
     - Physical identifier of the currently running application
   * - Thread ID
     - Internal identifier of the control thread
   * - Domain
     - ``access``, ``log``, ``out``
   * - Payload
     - A data whose format will depend on the value of the ``Domain``


ACCESS logs
~~~~~~~~~~~

When a request has been managed, the service in charge will drop a single
line in its ACCESS log. All these lines have the same format: the common header
carries the ``access`` domain, and the payload is formatted as follows.

.. list-table:: ACCESS header
   :widths: 20 100

   * - Level
     - A value in the set: **ERR**, **WRN**, **NOT**, **INF**, **DBG**, **TR0**, **TR1**
   * - Local Address
     - The local network address the service is bound to
   * - Remote Address
     - The network address of the peer that connected to the service
   * - Request Type
     - The name of the request, a.k.a. the RPC method.
   * - Return Code
     - The numeric return code of the message.
   * - Response Time
     - How many microseconds it took to handle the request until a reply was ready (but not sent yet!)
   * - Response Size
     - How many bytes have been serialized for the reply. In case of HTTP requests, this doesn't include the headers.
   * - User ID
     - The ID of the end-user the request is issued for
   * - Session ID
     - The ID of the user's session, sometimes also named Request-Id, used for aggregation purposes.
   * - Payload
     - An arbitrary payload, often organized as a sequence of ``key=value`` pairs.


Let's mention the case of the ACCESS log for outgoing requests. It is triggered
by an option in the central configuration file, and the format of each line is
exactly the same as for incmong requests, excepted that the Domain in the
common envelope is set to ``out``.


DEBUG logs
~~~~~~~~~~

Any service might also emit traces, are they impulsed by a request or by a
background task. The format is much more unprecise, dedicated for debugging
purposes, destined to be read by a human more than a parser.

.. list-table:: DEBUG header
   :widths: 20 100

   * - Level
     - A value in the set: **ERR**, **WRN**, **NOT**, **INF**, **DBG**, **TR0**, **TR1**
   * - Payload
     - An arbitrary message.


Example
~~~~~~~

Let's consider this following lines, and see how it decomposes.

.. code-block:: text

    2017-04-25T17:00:01.094517+02:00 localhost OIO,OPENIO,meta0,1[12159]: 12159 1E9A access INF 127.0.0.1:6004 127.0.0.1:48780 M0_GET 200 89 91 - 742FBB9DC7674C7C7959957801F06B44 t=63 AAA0

The first 3 fields are set by syslog, and that why the process ID is redundant
on that host.

.. list-table:: Fields from the common envelope
   :widths: 20 100

   * - Timestamp
     - `2017-04-25T17:00:01.094517+02:00`
   * - Hostname
     - `localhost`
   * - Instance ID
     - `OIO,OPENIO,meta0,1[12159]:`
   * - Process ID
     - `12159`
   * - Thread ID
     - `1E9A`
   * - Domain
     - `access`

The Domain mention it is a line for the access log, let's unpack this.

.. list-table:: Fields from the ACCESS envelope
   :widths: 20 100

   * - Level (ACCESS)
     - `INF`
   * - Local Address
     - `127.0.0.1:6004`
   * - Remote Address
     - `127.0.0.1:48780`
   * - Request Type
     - `M0_GET`
   * - Return Code
     - `200`
   * - Response Time
     - `89`
   * - Response Size
     - `91`
   * - User ID
     - `-`
   * - Session ID
     - `742FBB9DC7674C7C7959957801F06B44`
   * - Payload
     - `t=63 AAA0`

In this example, all the fields are always present as expected, but one
missing fields has been valuated by a dash. The final field is has an arbitrary
(or unspecified) format, it depends from the service implementation.

The key ``t=`` is used to explain the time spent by a worker thread, once the
request has been polled out of the queue in front of the thread pool.

Another well-known key OpenIO SDS uses is ``e=`` to explain the root cause of
the error that occured. At the moment, there is no common format for that
error, but we tend to explain the error as a JSON object with ``status`` and a
``message`` field.


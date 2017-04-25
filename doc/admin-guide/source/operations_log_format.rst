==========
Log Format
==========

COMMON enveloppe
~~~~~~~~~~~~~~~~

The services in an OpenIO system respect a common format for their logs. Each
log item is a single line of text, encoded in UTF-8. A line is a sequence of
items separated by a sequence of white spaces. For an easy parsing, the variety
of the messages is organized around a recursion of enveloppes (header and
payload).

.. list-table:: Common Header
   :header-rows: 1
   :widths: 20 100

   * - Field
     - Description
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
     - **access** or **log**
   * - Payload
     - A data whose format will depend on the value of the **Domain**

All the messages share this enveloppe, and the parsing of the payload is
deduced from the value of the domain.

ACCESS logs
~~~~~~~~~~~

When a request has been managed, the service in charge will drop a single
line in its ACCESS log. All these lines have the same format (after the
common header, of course).

.. list-table:: ACCESS header
   :header-rows: 1
   :widths: 20 100

   * - Field
     - Description
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
     - The ID of the user's session, sometimes also named Request-I, used for aggregation purposes.
   * - Payload
     - An arbitrary payload, often organized as a sequence of **key=value** pairs.

DEBUG logs
~~~~~~~~~~

Any service might also emit traces, are they impulsed by a request or by a
background task. The format is much more unprecise, dedicated for debugging
purposes, destined to be read by a human more than a parser.

.. list-table:: DEBUG header
   :header-rows: 1
   :widths: 20 100

   * - Field
     - Description
   * - Level
     - A value in the set: **ERR**, **WRN**, **NOT**, **INF**, **DBG**, **TR0**, **TR1**
   * - Payload
     - An arbitrary message.


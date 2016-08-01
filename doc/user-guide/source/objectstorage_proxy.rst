
***************************
OpenIO's proxy for metadata
***************************

The early days
==============

At the very beginning of OpenIO's ancestor, in june 2006 all the services spoke
their own protocol. The team wanted a packed form that was space- and
time-efficient, more than human readable (a.k.a. easy to debug). So we designed
a protocol based on message exchanges, where messages where described with
`ASN.1`_ and encoded/decoded with BER_. At this point in time, there was no
Protobuf_, Thrift_ of MsgPack_ available.

The first C client implementation connected directly to all the services it
targeted. So, in order to download a content, it contacted the META0 directory
to locate the META1, then contacted the META1 to find the META2, and finally
retrieved the chunks locations from the container managed by the META2.

The client had been designed to be a long-living structure, with a life-time
nearly as long as the processes. The META0's content is a highly static piece of
information, so instead of getting the only one META0 entry we wanted, its whole
content was downloaded once and kept cached.

.. image:: ../../../images/openio-client-no-proxy.svg


The metacd era
==============

The rise
--------

We immediately noticed the META0 information was huge (~1.3MiB multiplied by the
number of META1 replcias), took quite long to download, required too many
bandwidth, and consumed too much RAM when the client was used by the hundreds of
imapd processes of Cyrus_.

The solution was to share that information, and centralize it in a "cache daemon"
that should act nearly like the ``nscd``: accessed with a UNIX socket it is used
if present, but the C client should continue to work if not found. As a result,
a huge drop of memory consumption, a huge bandwidth drop, a noticeable CPU
consumption drop and best of all: a lower latency because of the much faster
client startup. Cool!

We soon noticed a room for an evolution of the metacd. Another information was
highly static and naturally sharded: the services locations stored in the META1
directory. The staticity came from the low need for containers migrations, the
sharding came from the design itself of the messaging platform, and the number
of really active mailboxes (i.e. containers, i.e. cache entries) was low. This
has been added to the metacd and as a result, it happened yet another latency
drop. Very cool!

Still another improvement was possible. Another information reasonably static
(in other words, manageable in a cache, but with shorter timeouts): the
locations of the chunks of data stored in the meta2. Still better, the lifecycle
of an email was short enough to keep in the cache  This has been added also to
the metacd and as a result, it happened yet another latency drop. Cool ... but
we started to manage false-positives cache hits.

.. image:: ../../../images/openio-client-with-metacd.svg

The fall
--------

That design suffered some drawbacks. We list here some of them, with no
pretention to be exhaustive, and no objective priority ordering:

* The metacd was just an option, and the client still embedded all the directory
  logic.
* It had yet another `ASN.1`_ / BER_ based protocol, different from the others. The
  cause was the metacd provided the macro-operations of the API, and not the
  proxied version of the low-level RPC.
* The metacd was mandatorily accessed through UNIX sockets. Though this was a
  great idea in the first production environment, there was no opportunity to
  use a single metacd shared among several hosts.
* We managed the transport layer, and we could have obtained reliable code
  faster with the used of message oriented libraries like ZeroMQ_.
* The choice of `ASN.1`_ / BER_ was poor when considering the community adoption,
  thus the portage into common language.
* Any simple interface or logic change caused a real pain when it became
  necessary to upgrade hundreds of hosts. The directory's logic was too present
  in every little client.

The oio-proxy era
=================

At a point, adapting the metacd started to cost much more than reimplementing it
another way. This "reboot" happened with several guidelines:

* "Light is right": the library embedded into applications should not be as big
  as in the early years.
* A mandatory proxy (at least "highly recommended"), because a shared cache is
  good for almost every user.
* A standard and well-supported protocol for the Session/Presentation layers.
  HTTP came naturally and, until now, its overhead (CPU/Network/Mem) is seamless.

.. image:: ../../../images/openio-client-with-proxy.svg

.. _`ZeroMQ`: http://zeromq.org
.. _`ASN.1`: https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One
.. _BER: https://en.wikipedia.org/wiki/X.690#BER_encoding
.. _Cyrus: https://cyrus.foundation/
.. _Protobuf: https://developers.google.com/protocol-buffers/
.. _MsgPack: http://msgpack.org/
.. _Thrift: https://thrift.apache.org/
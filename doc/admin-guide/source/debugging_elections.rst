===========================
Election troubles
===========================

The problem
-----------

You just wanted to set a property on a container, but then shit happens!

  .. code-block:: console

    > openio container set FVE0 --property a=1
    Open/lock: Election failed [697ECB056A5F9339B36C3B0A020B5AB17B4B0160FBEBEA203315EA1FC1B61605.1][meta2] (HTTP 503) (STATUS 503)

You go check meta2 logs, but they don't really help you.

  .. code::

    Oct 10 17:26:59.829349 linux-cgzg OIO,NS,meta2,1[29617]: 29617 C448 log WRN oio.sqlite TIMEOUT! (waiting for election status) [697ECB056A5F9339B36C3B0A020B5AB17B4B0160FBEBEA203315EA1FC1B61605.1.meta2] step=6/CHECKING_SLAVES
    Oct 10 17:26:59.829420 linux-cgzg OIO,NS,meta2,1[29617]: 29617 C448 access INF 127.0.0.1:6015 127.0.0.1:34710 DB_PSET 503 5001321 168 697ECB056A5F9339B36C3B0A020B5AB17B4B0160FBEBEA203315EA1FC1B61605 C26A69B0F22EF0D8A0D635D9EBD639F7 t=5001294 697ECB056A5F9339B36C3B0A020B5AB17B4B0160FBEBEA203315EA1FC1B61605.1.meta2 e=(503) Open/lock: Election failed [697ECB056A5F9339B36C3B0A020B5AB17B4B0160FBEBEA203315EA1FC1B61605.1][meta2]


Getting information
-------------------

Since openio-sds 4.2.0, there is a CLI for election debugging.
You can reproduce the election issue by running ``openio election status``,
with the type of the problematic service, and the name of the container
(alternatively, you can use the option ``--cid`` and the name of the base).

  .. code-block:: console

    > openio election status meta2 FVE0
    +----------------+--------+----------------------------------------------------------------------------------------------+
    | Id             | Status | Message                                                                                      |
    +----------------+--------+----------------------------------------------------------------------------------------------+
    | 127.0.0.1:6015 |    500 | Election failed for 697ECB056A5F9339B36C3B0A020B5AB17B4B0160FBEBEA203315EA1FC1B61605.1.meta2 |
    | 127.0.0.1:6017 |      7 | Timeout                                                                                      |
    | 127.0.0.1:6018 |      7 | Timeout                                                                                      |
    +----------------+--------+----------------------------------------------------------------------------------------------+



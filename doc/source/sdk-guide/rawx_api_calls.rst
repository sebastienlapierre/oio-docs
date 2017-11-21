
GET /update/{CHUNKID}
~~~~~~~~~~~~~~~~~~~~~

Despite the GET verb, this route alters the metadata of the chunk.

.. list-table:: URL tokens
   :header-rows: 1
   :widths: 10 20

   * - Token
     - Description
   * - CHUNKID
     - a string of 64 hexadecimal characters


.. list-table:: Headers
   :header-rows: 1
   :widths: 10 20

   * - Header
     - Description
   * - X-oio-chunk-meta-container-id
     - String of 64 hexadecimal characters
   * - X-oio-chunk-meta-content-path
     - A string
   * - X-oio-chunk-meta-content-id
     - String of hexadecimal characters, usually of 32 characters. The only constraint
       is that the number must be even, to be convertible to a binary form.
   * - X-oio-chunk-meta-content-version
     - A strictly positive integer, less than (2^63). That integer SHOULD match the
       number of bytes of the targeted chunk.
   * - X-oio-chunk-meta-content-storage-policy
     - A string, no check will be performed, at the RAWX level the string might even
       represent a non-existing storage policy
   * - X-oio-chunk-meta-content-chunk-method
     - A string. At the RAWX level no check will be performed and that string
       might even be an invalid chunk-method description.
   * - X-oio-chunk-meta-metachunk-size
     - A null or positive number
   * - X-oio-chunk-meta-metachunk-hash
     - A string of 32 hexadecimal characters
   * - X-oio-chunk-meta-chunk-id
     - A string of 64 hexadecimal characters that must math the CHUNKID present in
       the URL
   * - X-oio-chunk-meta-chunk-size
     - A null or positive integer
   * - X-oio-chunk-meta-chunk-hash
     - A string of 32 hexadecimal characters
   * - X-oio-chunk-meta-chunk-pos
     - Either a positive integer (including 0) or a compound of 2 positive integers
       gathered with a dot.
   * - X-oio-chunk-meta-oio-version
     - A string describing the versin of the headers.
   * - X-oio-chunk-meta-full-path
     - A string representing a complete OpenIO URL


Example
-------

.. code-block:: http

   GET /update/0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF HTTP/1.1
   Content-Length: 0
   X-oio-chunk-meta-container-id: 9006CE70B59E5777D6BB410C57944812EB05FCDB5BA85D520A14B3051D1D094F
   X-oio-chunk-meta-content-path: magic
   X-oio-chunk-meta-content-id: 5835AF8D805E0500AAB7F6808F50900A
   X-oio-chunk-meta-content-version: 1511281109448048
   X-oio-chunk-meta-content-storage-policy: EC
   X-oio-chunk-meta-content-chunk-method: ec/algo=liberasurecode_rs_vand,k=6,m=3
   X-oio-chunk-meta-metachunk-size: 111
   X-oio-chunk-meta-metachunk-hash: 272913026300E7AE9B5E2D51F138E674
   X-oio-chunk-meta-chunk-id: CE456217C7DBAC618A7F0EBFBCDB6C8F184ED8ADCBC6F0B6F493A51EE095D86A
   X-oio-chunk-meta-chunk-size: 100
   X-oio-chunk-meta-chunk-hash: 527EC56D67EF8DA68E3FB93158552272
   X-oio-chunk-meta-chunk-pos: 0.3
   X-oio-chunk-meta-oio-version: 4.0
   X-oio-chunk-meta-full-path: ACCT/JFS/magic/1511281109448048



.. code-block:: http

   HTTP/1.1 200 OK
   Content-Length: 0



GET /{CHUNKID}
~~~~~~~~~~~~~~

Download a chunk from the target RAWX service.
The chunk ID is given as a token of the URL.
No particular header is expected in the request.
The attributes of the chunk will be returned as headers of the reply.

.. list-table:: URL tokens
   :header-rows: 1
   :widths: 10 20

   * - Token
     - Description
   * - CHUNKID
     - a string of 64 hexadecimal characters


.. list-table:: Request Headers
   :header-rows: 1
   :widths: 10 20

   * - Header
     - Description
   * - Range
     - Both *chunked* and *inline* are managed


.. list-table:: Reply Headers
   :header-rows: 1
   :widths: 10 20

   * - Header
     - Description
   * - X-oio-chunk-meta-container-id
     - String of 64 hexadecimal characters
   * - X-oio-chunk-meta-content-path
     - A string
   * - X-oio-chunk-meta-content-id
     - String of hexadecimal characters, usually of 32 characters. The only constraint
       is that the number must be even, to be convertible to a binary form.
   * - X-oio-chunk-meta-content-version
     - A strictly positive integer, less than (2^63). That integer SHOULD match the
       number of bytes of the targeted chunk.
   * - X-oio-chunk-meta-content-storage-policy
     - A string, no check will be performed, at the RAWX level the string might even
       represent a non-existing storage policy
   * - X-oio-chunk-meta-content-chunk-method
     - A string. At the RAWX level no check will be performed and that string
       might even be an invalid chunk-method description.
   * - X-oio-chunk-meta-metachunk-size
     - A null or positive number
   * - X-oio-chunk-meta-metachunk-hash
     - A string of 32 hexadecimal characters
   * - X-oio-chunk-meta-chunk-id
     - A string of 64 hexadecimal characters that must math the CHUNKID present in
       the URL
   * - X-oio-chunk-meta-chunk-size
     - A null or positive integer
   * - X-oio-chunk-meta-chunk-hash
     - A string of 32 hexadecimal characters
   * - X-oio-chunk-meta-chunk-pos
     - Either a positive integer (including 0) or a compound of 2 positive integers
       gathered with a dot.
   * - X-oio-chunk-meta-oio-version
     - A string describing the versin of the headers.
   * - X-oio-chunk-meta-full-path
     - A string representing a complete OpenIO URL


Example
-------

.. code-block:: http

   GET /CE456217C7DBAC618A7F0EBFBCDB6C8F184ED8ADCBC6F0B6F493A51EE095D86A HTTP/1.1
   Host: 127.0.0.1:6009
   User-Agent: curl/7.55.1


.. code-block:: http

   HTTP/1.1 200 OK
   Date: Tue, 21 Nov 2017 16:19:57 GMT
   Server: Apache
   Last-Modified: Tue, 21 Nov 2017 16:18:29 GMT
   ETag: "55e808daf7710"
   Accept-Ranges: bytes
   Content-Length: 100
   X-oio-chunk-meta-container-id: 9006CE70B59E5777D6BB410C57944812EB05FCDB5BA85D520A14B3051D1D094F
   X-oio-chunk-meta-content-path: magic
   X-oio-chunk-meta-content-id: 5835AF8D805E0500AAB7F6808F50900A
   X-oio-chunk-meta-content-version: 1511281109448048
   X-oio-chunk-meta-content-storage-policy: EC
   X-oio-chunk-meta-content-chunk-method: ec/algo=liberasurecode_rs_vand,k=6,m=3
   X-oio-chunk-meta-metachunk-size: 111
   X-oio-chunk-meta-metachunk-hash: 272913026300E7AE9B5E2D51F138E674
   X-oio-chunk-meta-chunk-id: CE456217C7DBAC618A7F0EBFBCDB6C8F184ED8ADCBC6F0B6F493A51EE095D86A
   X-oio-chunk-meta-chunk-size: 100
   X-oio-chunk-meta-chunk-hash: 527EC56D67EF8DA68E3FB93158552272
   X-oio-chunk-meta-chunk-pos: 0.3
   X-oio-chunk-meta-oio-version: 4.0
   X-oio-chunk-meta-full-path: ACCT/JFS/magic/1511281109448048

   ...


PUT /{CHUNKID}
~~~~~~~~~~~~~~

Upload a chunk on the target RAWX service.

.. list-table:: URL tokens
   :header-rows: 1
   :widths: 10 20

   * - Token
     - Description
   * - CHUNKID
     - a string of 64 hexadecimal characters


.. list-table:: HTTP Headers
   :header-rows: 1
   :widths: 10 20

   * - Header
     - Description
   * - Transfer-Encoding
     - Both *chunked* and *inline* are managed


.. list-table:: RAWX Headers
   :header-rows: 1
   :widths: 10 20

   * - Header
     - Description
   * - X-oio-chunk-meta-container-id
     - String of 64 hexadecimal characters
   * - X-oio-chunk-meta-content-path
     - A string
   * - X-oio-chunk-meta-content-id
     - String of hexadecimal characters, usually of 32 characters. The only constraint
       is that the number must be even, to be convertible to a binary form.
   * - X-oio-chunk-meta-content-version
     - A strictly positive integer, less than (2^63). That integer SHOULD match the
       number of bytes of the targeted chunk.
   * - X-oio-chunk-meta-content-storage-policy
     - A string, no check will be performed, at the RAWX level the string might even
       represent a non-existing storage policy
   * - X-oio-chunk-meta-content-chunk-method
     - A string. At the RAWX level no check will be performed and that string
       might even be an invalid chunk-method description.
   * - X-oio-chunk-meta-metachunk-size
     - A null or positive number
   * - X-oio-chunk-meta-metachunk-hash
     - A string of 32 hexadecimal characters
   * - X-oio-chunk-meta-chunk-id
     - A string of 64 hexadecimal characters that must math the CHUNKID present in
       the URL
   * - X-oio-chunk-meta-chunk-size
     - A null or positive integer
   * - X-oio-chunk-meta-chunk-hash
     - A string of 32 hexadecimal characters
   * - X-oio-chunk-meta-chunk-pos
     - Either a positive integer (including 0) or a compound of 2 positive integers
       gathered with a dot.
   * - X-oio-chunk-meta-oio-version
     - A string describing the versin of the headers.
   * - X-oio-chunk-meta-full-path
     - A string representing a complete OpenIO URL


Example
-------

.. code-block:: http

   PUT /0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF HTTP/1.1
   Content-Length: 12345
   X-oio-chunk-meta-container-id: 9006CE70B59E5777D6BB410C57944812EB05FCDB5BA85D520A14B3051D1D094F
   X-oio-chunk-meta-content-path: magic
   X-oio-chunk-meta-content-id: 5835AF8D805E0500AAB7F6808F50900A
   X-oio-chunk-meta-content-version: 1511281109448048
   X-oio-chunk-meta-content-storage-policy: EC
   X-oio-chunk-meta-content-chunk-method: ec/algo=liberasurecode_rs_vand,k=6,m=3
   X-oio-chunk-meta-metachunk-size: 111
   X-oio-chunk-meta-metachunk-hash: 272913026300E7AE9B5E2D51F138E674
   X-oio-chunk-meta-chunk-id: CE456217C7DBAC618A7F0EBFBCDB6C8F184ED8ADCBC6F0B6F493A51EE095D86A
   X-oio-chunk-meta-chunk-size: 100
   X-oio-chunk-meta-chunk-hash: 527EC56D67EF8DA68E3FB93158552272
   X-oio-chunk-meta-chunk-pos: 0.3
   X-oio-chunk-meta-oio-version: 4.0
   X-oio-chunk-meta-full-path: ACCT/JFS/magic/1511281109448048

   -snip-


.. code-block:: http

   HTTP/1.1 200 OK
   Content-Length: 0



DELETE /{CHUNKID}
~~~~~~~~~~~~~~~~~

Delete a chunk stored on the target RAWX service.

.. list-table:: URL tokens
   :header-rows: 1
   :widths: 10 20

   * - Token
     - Description
   * - CHUNKID
     - a string of 64 hexadecimal characters


Example
-------

.. code-block:: http

   DELETE /0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF HTTP/1.1
   Content-Length: 0


.. code-block:: http

   HTTP/1.1 204 No content
   Content-Length: 0




GET /info
~~~~~~~~~~~

Returns some static information about the targeted RAWX service.
No particular header is expected, neither in the request nor in the reply.

.. code-block:: http

   GET /info HTTP/1.1
   Host: 127.0.0.1
   Content-Length: 0


.. code-block:: http

   HTTP/1.1 200 OK
   Content-Length: 60

   namespace OPENIO
   path /home/jfs/.oio/sds/data/OPENIO-rawx-4



GET /stat
~~~~~~~~~~~

Returns some volatile counters and gauges about what's happening in the targeted RAWX service.

Sample exchange:

.. code-block:: http

   GET /stat HTTP/1.1
   Host: 127.0.0.1
   Content-Length: 0


.. code-block:: http

   HTTP/1.1 200 OK
   Content-Length: 625

   counter req.time 436106
   counter req.time.put 0
   counter req.time.get 0
   counter req.time.del 0
   counter req.time.stat 3612
   counter req.time.info 3613
   counter req.time.raw 0
   counter req.time.other 0
   counter req.hits 7225
   counter req.hits.put 0
   counter req.hits.get 0
   counter req.hits.del 0
   counter req.hits.stat 3612
   counter req.hits.info 3613
   counter req.hits.raw 0
   counter req.hits.other 0
   counter rep.hits.2xx 7225
   counter rep.hits.4xx 2
   counter rep.hits.5xx 0
   counter rep.hits.other 0
   counter rep.hits.403 0
   counter rep.hits.404 0
   counter rep.bread 0
   counter rep.bwritten 0


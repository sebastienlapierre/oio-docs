==================
Chunk Volume Index
==================

In OpenIO SDS, chunks are indexed by volume.
This enables fast search through a chunk volume.
Internally the index is stored using leveldb.

Chunk volume are indexed asynchronously when write operations
are performed on a chunk server.

The chunk volume index main purpose is for self-healing operations.

Volume Rebuild
~~~~~~~~~~~~~~

To rebuild a lost volume, the rebuild tool first retrieves the
list of chunks on the volume and then locates chunk replicas to
perform the repair.

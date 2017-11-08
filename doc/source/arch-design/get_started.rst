=======================
Get started with OpenIO
=======================

The OpenIO project is an open source cloud platform for all
sizes of platforms, which aims to be easy to use, install and connect
with your applications.

OpenIO provides a cloud platform built around storage for your applications,
for that it provides a set of interrelated services, each service offers a
dedicated API to facilitate integration.

Depending on your needs, you can install some or all services.

The following table describes the OpenIO services that make up the
OpenIO Architecture:

.. list-table:: OpenIO Services
   :header-rows: 1
   :widths: 10 40

   * - Service
     - Description
   * - Conscience (Core)
     - Manages service discovery and load balancing through realtime metrics.
   * - Service Directory (Core)
     - Manages stateful associations between applications backend and end users.
   * - Object Storage
     - Stores and retrieves unstructured data.
   * - Indexing service
     - Index and search documents.
   * - Transcoding service
     - Transcode medias (audio, video, image) in a scale out fashion.
   * - Database service
     - Provides a scalable and fault-tolerant Cloud Database.
   * - Streaming service
     - Provides HTTP adaptive streaming video functionality.

.. note::

   Note that Core Services are always required to run OpenIO.

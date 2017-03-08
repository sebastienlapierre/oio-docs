==========
AWS S3 CLI
==========

This guide provides a few hints to help users getting started with the [AWS S3 command line client](https://aws.amazon.com/cli/) using the OpenIO Swift gateway. By default, the gateway uses the [Swift3](https://github.com/openstack/swift3) middleware to allow the access to OpenIO object storage using Amazon S3 API.  
The AWS CLI allows to use the different APIs provided by AWS, including the [S3](http://docs.aws.amazon.com/cli/latest/reference/s3/) and [S3API](http://docs.aws.amazon.com/cli/latest/reference/s3api/) ones.  

Configuration
=============

To use the AWS command, you need to set your credentials in the `~/.aws/credentials` file:

   .. code-block:: console

      # mkdir ~/.aws
      # echo "[default]
      aws_access_key_id=demo:demo
      aws_secret_access_key=DEMO_PASS" >~/.aws/credentials

You can also set specific parameters for the S3 commands:

   .. code-block:: console

     # echo "[default]
     s3 =
     max_concurrent_requests = 10
     max_queue_size = 100
     multipart_threshold = 1GB
     multipart_chunksize = 10MB" >~/.aws/config

Usage
=====

You will need to provide the command line the endpoint of the Swift gateway and disable the SSL verification, as it is not provided by default.  

Create a bucket
---------------

   .. code-block:: console

     # aws --endpoint-url http://localhost:6007 --no-verify-ssl s3api create-bucket --bucket test1

List buckets
------------

   .. code-block:: console

     # aws --endpoint-url http://localhost:6007 --no-verify-ssl s3 ls

Upload a content
----------------

   .. code-block:: console

     # aws --endpoint-url http://localhost:6007 --no-verify-ssl s3 cp /etc/magic s3://test1


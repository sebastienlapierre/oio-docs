=========
S3 Client
=========

Installation
~~~~~~~~~~~~

Install the OpenStack Swift Command Line Interface:

   .. only:: ubuntu or debian
   
      .. code-block:: console
           
         # apt-get install python-swiftclient
   
   .. only:: centos
   
      .. code-block:: console 
   
         # yum install python-swiftclient

You need to export these variables to use the S3 CLI. Create a file `keystonerc_demo` containing:
   
   .. code-block:: console

    export OS_TENANT_NAME=demo
    export OS_USERNAME=demo
    export OS_PASSWORD=DEMO_PASS
    export OS_AUTH_URL=http://localhost:5000/v2.0

Create your credentials:Create your credentiCreate your credentials:

   .. code-block:: console

    # keystone ec2-credentials-create

You can configure an AWS config file to avoid typing them (replace ACCESS_KEY and SECRET_KEY with the previous output):

   .. code-block:: console

    # mkdir ~/.aws

    # vi ~/.aws/credentials

   .. code-block:: console

    [default]
    aws_access_key_id=ACCESS_KEY
    aws_secret_access_key=SECRET_KEY

   .. code-block:: console

    # vi ~/.aws/config

   .. code-block:: console

    [default]
    s3 =
      max_concurrent_requests = 20
      max_queue_size = 1000
      multipart_threshold = 10GB
      multipart_chunksize = 16MB


Install the awscli:

   .. only:: ubuntu or debian

      .. code-block:: console

         # apt-get install python-pip

   .. only:: centos

      .. code-block:: console

         # yum install python-pip

   .. code-block:: console

    # pip install awscli


Usage
~~~~~

You can now use the AWS CLI, using the ipaddress of your box:

   .. code-block:: console

    # aws --endpoint-url http://localhost:6007 --no-verify-ssl s3 cp /etc/magic s3://TEST_BUCKET

   .. code-block:: console

    # aws --endpoint-url http://localhost:6007 --no-verify-ssl s3 ls s3://TEST_BUCKET

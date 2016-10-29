======
Deploy
======

First, pull the OpenIO docker image from the Docker Hub:

   .. code-block:: console

    # docker pull openio/sds

By default, start a simple namespace listening on 127.0.0.1 inside the container using docker run:

   .. code-block:: console

    # docker run -ti --tty openio/sds
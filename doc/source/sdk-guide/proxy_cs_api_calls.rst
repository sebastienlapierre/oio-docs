
POST /v3.0/{NS}/conscience/register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Register one service:

.. code-block:: json

   {
     "addr": "127.0.0.1:6000",
     "tags": { "stat.cpu": 100, "stat.idle": 100, "stat.io": 100 }
   }

Register several services at once:

.. code-block:: json

   [
     { "addr": "127.0.0.1:6000",
       "tags": { "stat.cpu": 100, "stat.idle": 100, "stat.io": 100 } },
     { "addr": "127.0.0.1:6000",
       "tags": { "stat.cpu": 100, "stat.idle": 100, "stat.io": 100 } }
   ]



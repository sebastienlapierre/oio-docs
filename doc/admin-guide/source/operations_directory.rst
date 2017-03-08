==================
Directory commands
==================

Directory Lookup
~~~~~~~~~~~~~~~~

account/reference
compute the CID using SHA256 and get the prefix.
Locate the directory server managing the given prefix.
This directory lookup is always cached by clients.

Reference Create
~~~~~~~~~~~~~~~~

Perform the lookup and create a new reference.

Reference List
~~~~~~~~~~~~~~

list the currently linked services to this reference.


Reference Destroy
~~~~~~~~~~~~~~~~~

can not be destroyed if there are still linked services.


Reference Link
~~~~~~~~~~~~~~

Associate a particular set of services to a reference.
Choose services, respecting distance constraints

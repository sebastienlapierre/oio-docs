1. Keep your system updated:

  .. code-block:: console

    # yum update -y

2. Disable SELinux:

  .. code-block:: console
 
    # sed -i -e 's@^SELINUX=enforcing$@SELINUX=disabled@g' /etc/selinux/config

3. Disable firewall:

  .. code-block:: console

    # systemctl stop firewalld.service ; systemctl disable firewalld.service

4. Reboot to apply changes:

  .. code-block:: console

    # reboot


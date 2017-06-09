1. Keep your system updated:

  .. code-block:: console

    # sudo yum update -y

2. Disable SELinux:

  .. code-block:: console
 
    # sudo sed -i -e 's@^SELINUX=enforcing$@SELINUX=disabled@g' /etc/selinux/config

3. Disable firewall:

  .. code-block:: console

    # sudo systemctl stop firewalld.service ; sudo systemctl disable firewalld.service

4. Reboot to apply changes:

  .. code-block:: console

    # sudo reboot


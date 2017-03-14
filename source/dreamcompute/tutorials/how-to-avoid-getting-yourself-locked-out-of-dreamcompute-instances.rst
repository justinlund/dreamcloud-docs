==================================================================
how to avoid getting yourself locked out of DreamCompute instances
==================================================================

Introduction
~~~~~~~~~~~~

DreamCompute instances are created with a specified SSH key which is used for
gaining initial access.  Here are a couple recommendations to prevent getting
locked out of your DreamCompute instance.

Preventing future lockouts
~~~~~~~~~~~~~~~~~~~~~~~~~~

* **Set a password for the default user**

  By default the ssh configuration file (/etc/ssh/sshd_config) does not allow
  for password authentication, so it can be safe and advised to set a strong
  password for your default user.  Should one become locked out, using the
  "Console" in the DreamCompute dashboard allows default user login, and from
  there you can sudo to fix possible issues, set a new ssh key, and so on.

* **Create your own users**

  It is not required to use the default usernames provided by the operating
  system.  Once logged in with the default user, additional users can be
  created and each of those given different ssh keys for other users.  The
  default user and its SSH key can be a backup access option, rather than
  the only login option.

* **Make backups**

  Being an unmanaged service, the customer is responsible for their own data.
  If there are important data, configuration files, and so on that you wish to
  keep safe, please consider installing a S3 CLI client like `s3cmd <215916627-How-to-use-S3cmd-with-DreamObjects>`_,
  `boto-rsync <217473218-How-to-use-boto-rsync-with-DreamObjects>`_,
  `awscli <216335908-How-to-use-AWS-CLI-with-DreamObjects>`_
  or another tool from the `DreamObjects applications <218339127-What-Applications-Are-Compatible-With-DreamObjects>`_
  page.

.. meta::
    :labels: dreamcompute

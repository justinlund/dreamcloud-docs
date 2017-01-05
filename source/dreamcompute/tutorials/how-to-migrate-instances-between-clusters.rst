======================================================
How to migrate instances between DreamCompute clusters
======================================================

Introduction
~~~~~~~~~~~~

DreamCompute offers multiple clusters (also often called availability zones)
which are independent OpenStack installations with their own servers, storage
and control panel.  Some clusters have different features, such as SSD storage
or different hardware that is useful for a given task.  Migrating instances
and data between clusters is not automated at this time, and this guide will
show you how to accomplish this yourself.

This guide assumes that you are comfortable working with SSH, and some
command line utilities such as `dd <http://man7.org/linux/man-pages/man1/dd.1.html>`_
and `openstack <http://docs.openstack.org/developer/python-openstackclient/man/openstack.html>`_.

Things to keep in mind
~~~~~~~~~~~~~~~~~~~~~~

Here are a few things to keep in mind and plan while doing a migration.

* **IP addresses will change**

  Each cluster has assigned blocks of IP addresses, and therefore floating IPs,
  public IPv4, and public IPv6 addresses cannot be transferred between clusters.
  If you are using private networks (required in US-East 1 and optional in
  US-East 2), the specific assigned 10.x.x.x address may also change.

* **SSH keys**

  Each cluster manages its SSH Keys separately, so if you have your keys
  already setup in US-East 1, you will have to setup the same keys or new
  ones in US-East 2.  If OpenStack generated the SSH Key for you, it let you
  download the private key but the public key is what you would need for an
  import.  You could grab it from the ~/.ssh/authorized_keys file on an
  instance that used the key.  For the instances themselves, the
  authorized_keys file is only appended to, not overwritten, so whatever keys
  are currently setup will continue to work after the move.

* **Plan a maintenance window**

  To avoid open files causing corruption or other odd behavior, it is safest
  to move the data when the instance is not running.  The copying of the data is
  generally pretty quick for smaller volumes, but for larger volumes it could take
  some time.  Remember, the copy needs to complete before service can be restored.
  Also, DNS will need to be updated from the old public IPs to the new ones.
  Depending on the TTL (time to live) of your DNS provider, this process can be
  a matter of minutes, or take 24 hours.  DNS zones managed by DreamHost can have the
  TTL changed from 4 hours to 5 minutes if you contact support at least 24 hours in
  advance of your changes. This can help minimize propagation time.

* **Ephemeral instances**

  Ephemeral instances cannot be used as the source of a snapshot and cannot
  have their data accessed by another instance when shut off.  These instances can only be
  migrated while running, so it is best to shut down as many services as possible (like
  MySQL, Apache, and so on) to limit the possibility of corruption.  Please see the last
  section below on how to migrate running instances.

Migrate a volume-backed instance using the OpenStack CLI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For this type of move, it is necessary to delete the instance so that it leaves
behind the volume to migrate.  This method requires that you did not check
the "delete on terminate" box when you created your instance.  If you did,
please skip to the last section on migrating running instances.  If you
continue you may permanently destroy and lose your data.

As an overview, here are the components involved in accomplishing this task.

.. code::

        SOURCE CLUSTER         DESTINATION CLUSTER

       +---------------+     +----------------------+     +-------------------+
       | Temp Instance |---->| Glance Image Service |---->| Migrated Instance |
       +---------------+     +----------------------+     +-------------------+
               |(mount)
       +----------------+
       | Volume To Copy |
       +----------------+

Let's go!

1.  Create a new instance, using the smallest available flavor, to be used as
a copy machine.  This guide will be using Ubuntu 14.04, but the commands should
be similar on any Ubuntu system.  It is also recommended that you make the
instance ephemeral, since it will not be needed after the migration is complete.

2.  Install the needed software to access the glance image service on this new instance.

.. code-block:: console

    [root@server]# apt-get install python-dev python-pip
    [root@server]# pip install python-openstackclient

After this, run "openstack help" and check for any other modules that it says are
missing.  Install them with:

.. code-block:: console

    [root@server]# pip install MODULENAME

3.  Setup your OpenStack RC file for the DESTINATION cluster on this new
instance, which can be downloaded from its Access & Security -> API Access menu
in the dashboard.  Either upload the file to your instance, or copy/paste its
contents into a file on this instance.  Once you are done, you can run it like
so.

.. code-block:: console

    [root@server]# vi dreamcompute-CLUSTER.sh
    <paste the contents, save>
    [root@server]# . dreamcompute-CLUSTER.sh

It will then prompt you to "Please enter your OpenStack Password:"; go
ahead and do that.

If you run a command like the below, it should output the current OpenStack images
in the destination cluster.

.. code-block:: console

    [root@server]# openstack image list

4.  Delete the instance that you wish to move, freeing up its volume to be
attached to the above newly created instance.

5.  To attach the volume to the new instance, go to the Volumes menu, click on the
drop-down box in the "Actions" column on the right side, and then click "Edit Attachments".

6.  On the new instance, check "dmesg" for the drive letter of the new volume. You can also check
the usual names for it.

.. code-block:: console

    [root@server]# fdisk -l /dev/vdb | grep Disk
    [root@server]# fdisk -l /dev/vdc | grep Disk

One of those should match the size of the volume you are trying to move.  Make
note of the drive letter (the /dev/vdX part).

7.  Now use dd to pipe the data directly into the glance image service.
Don't forget to change the drive letter in the example below to the one you found
above. You can also change any text in all CAPS to suit your taste.

.. code-block:: console

    [root@server]# dd if=/dev/vdX | openstack image create \
        --private --container-format bare \
        --disk-format raw "INSTANCENAME"

8.  Wait for this command to finish running. If successful, it should output the info about the
new image that was created.

9.  You are now ready to go to the DESTINATION cluster to start up a new
instance and to select the image that was just uploaded.  If the data is
meant to be persistent, it is best to use the "Boot from image (creates
a new volume) option.

Migrate an ephemeral instance using the OpenStack CLI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This type of migration is not recommended.  It may be necessary in some
situations however and so is included here.

1.  Shut down as many services as possible, such as database servers, http
servers, etc, ideally leaving only default system tools and sshd running.

2.  Install the needed software to access the glance imaging service on
this new instance.

.. code-block:: console

    [root@server]# apt-get install python-dev python-pip
    [root@server]# pip install python-openstackclient

After this, run "openstack help" and check for any other modules that it says
are missing.  Install them with:

.. code-block:: console

    [root@server]# pip install MODULENAME

3.  Setup your OpenStack RC file for the DESTINATION cluster on this new
instance, which can be downloaded from its Access & Security -> API Access menu
in the dashboard.  Either upload the file to your instance, or copy/paste its
contents into a file on this instance.  Once you are done, you can run it like
so.

.. code-block:: console

    [root@server]# vi dreamcompute-CLUSTER.sh
    <paste the contents, save>
    [root@server]# . dreamcompute-CLUSTER.sh

It will then prompt you to "Please enter your OpenStack Password:"; go
ahead and do that.

If you run a command like the one below, it should output the current OpenStack
images in the destination cluster.

.. code-block:: console

    [root@server]# openstack image list

4.  Determine the drive letter by examining the output of "df -h" for the root
(/) filesystem.  Generally this will be /dev/vda1.

5.  Now use dd to pipe the data from the disk directly into the the glance image service.
Change any text in all CAPS to suit your taste.

.. code-block:: console

    [root@server]# dd if=/dev/vda | openstack image create \
        --private --container-format bare \
        --disk-format raw "INSTANCENAME"

6.  Wait for the command to finish running. If successful, it should output the info about the
new image that was created.

7.  You are now ready to go to the DESTINATION cluster to start up a new
instance and to select the image that was just uploaded.  If the data is
meant to be persistent, it is best to use the "Boot from image (creates
a new volume) option.

.. meta::
    :labels: glance migrate image

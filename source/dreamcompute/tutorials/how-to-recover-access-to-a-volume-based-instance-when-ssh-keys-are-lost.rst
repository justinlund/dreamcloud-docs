=======================================================================
How to recover access to a volume-based instance when ssh keys are lost
=======================================================================

Introduction
~~~~~~~~~~~~

DreamCompute instances are created with a specified SSH key which is used for
gaining initial access.  This guide covers some basic steps to attempt to
retrive the data, and gain access again if desired.

Things to keep in mind
~~~~~~~~~~~~~~~~~~~~~~

* **IP addresses will change**

  To get back into an instance requires re-creating it.  The new instance
  receives new IPv4 and IPv6 addresses.

* **Know your instance type**

  One can generally find out if an instance is ephemeral, or volume booted
  by looking at the dashboard in the Instances menu, and seeing if the name
  of an operating system is listed in the "Image Name" column.  If one is
  listed, the instance is ephemeral.  If one isn't, it is volume booted.

* **Backup volume booted instance**

  When an instance is created, there is a checkbox called "delete on
  terminate", which is difficult to check for after creation.  If this was
  checkboxed, when the instance is deleted the volume data will be as well.
  To make a backup, in the dashboard Instances menu, select "Create Snapshot"
  in the right drop-down menu.  This snapshot uses volume storage quota,
  so additional storage may need to be added in the DreamHost panel for
  room.  Once this process is complete, the snapshot can be deleted and the
  quota lowered.

Regain access to volume-based instance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  Navigate to the DreamCompute dashboard `Instances menu <https://iad2.dreamcompute.com/project/instances/>`_.

2.  If unsure if the "delete on terminate" was checkmarked for your instance,
    ensure a snapshot has been created.  Ensure there is sufficient volume
    storage on the `project overview <https://iad2.dreamcompute.com/project/>`_
    page.  A snapshot uses as much disk space as the volume, so if the volume
    is 80GB, ensure there is another 80GB free.

3.  Make note of the size of the instance, the name of the instance, the UUID
    and name of the volume, and any other features that should be retained in
    the new instance.

4.  Delete the instance, which will leave an available volume.

5.  Click on the "Launch Instance" button to create a new instance.  For the
    "Instance boot source", select "Boot from volume" and then the name of the
    volume the previous instance used.  On the "Access & Security" tab,
    select the Key Pair to be injected for the default user.  If
    there are no valid keys available, click the "+" symbol next to the drop-
    down to create a new one.  Click the "Launch" button on the bottom right.

4.  Once the new instance has booted, attempt to login to it with the
    `default username <https://help.dreamhost.com/hc/en-us/articles/228377408-How-to-find-the-default-user-of-an-image>`_
    and the new IP address.

5.  If all looks correct and access has been restored, the volume snapshot made
    in step #2 can be deleted.

.. meta::
    :labels: dreamcompute

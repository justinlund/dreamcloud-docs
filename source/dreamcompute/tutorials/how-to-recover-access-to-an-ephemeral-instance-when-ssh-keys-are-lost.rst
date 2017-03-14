=====================================================================
How to recover access to an ephemeral instance when ssh keys are lost
=====================================================================

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

Regain access to ephemeral instance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  Navigate to the DreamCompute dashboard `Instances menu <https://iad2.dreamcompute.com/project/instances/>`_.

2.  Click on the right-side menu, the action "Create Snapshot" and give the
    snapshot a name.  This creates an operating system image of your
    running instance.  Please wait for this process to complete, generally
    no more than a couple minutes.

3.  Click on the "Launch Instance" button to create a new instance.  For the
    "Instance boot source", select "Boot from image" and then the name of the
    snapshot created in the previous step.  On the "Access & Security" tab,
    select the Key Pair to be injected for the default user.  If
    there are no valid keys available, click the "+" symbol next to the drop-
    down to create a new one.  Click the "Launch" button on the bottom right.

4.  Once the new instance has booted, attempt to login to it with the
    `default username <https://help.dreamhost.com/hc/en-us/articles/228377408-How-to-find-the-default-user-of-an-image>`_
    and the new IP address.

5.  If all looks correct and access has been restored, the original instance
    can now be deleted.

.. meta::
    :labels: dreamcompute

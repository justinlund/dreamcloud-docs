===============================================
How to fix an unreachable DreamCompute Instance
===============================================

Introduction
~~~~~~~~~~~~

This guide is a checklist of common issues that can be investigated
before contacting support.  Please keep in mind that DreamHost support has no
access to login to your instances, or view your data so any error messages,
logs or other details of the issue will help resolve the issue, or point you
in the right direction to fix the issue faster.

Ensure the instance is running
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login to the DreamCompute `dashboard <https://iad2.dreamcompute.com/>`_ and
examine the `instances <https://iad2.dreamcompute.com/project/instances/>`_
page.  Examine the status and power state columns for the instance.  Some
common combinations of these values and their meaning are:

* **Status is "Active", Power State is "Running"**

  The instance is up and running from the DreamCompute side of
  things.  Please move to the next section.

* **Status is "Error"**

  The instance has encountered a serious error on the DreamCompute side.  The
  exact error can be seen by clicking on the instance name, then the Overview
  tab.  This error cannot be reset except by an administrator, please contact
  support.

* **Status is "Confirm or Revert Resize/Migrate"**

  A resize was attempted on this instance.  Please confirm or revert the resize
  by using the right-side drop-down menu to Confirm or Revert.

* **Status is "Paused"**

  The instance was paused from within the dashboard or API.  Click to menu item
  to resume the instance, and consider changing your password if this was not
  done to your knowledge.

* **Status is "Shutoff"**

  The instance was shut down.  This can happen by an admin user on the
  instance running a command like "shutdown -h now", a kernel panic, or less
  common an error on the DreamCompute side.  Before starting the instance,
  click on the instance name and then the "Log" tab.  It will show the last
  console output before shutdown.  It can be useful to see if it was an
  intentional shutdown or other issue.  If you contact support about this,
  please click the "View Full Log" button and include the output in the
  support ticket.

Any other status may require contacting support to fix the instance.

Check the instance log for boot errors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From the `Instances <https://iad2.dreamcompute.com/project/instances/>`_ page,
select "View Log".  This displays the last 35 lines of the consoles output.  A
properly booted instance has a login prompt.  The prompt could be slightly
buried.  An example Ubuntu 16 output would be:

.. code-block:: console

    [[0;32m  OK  [0m] Started Execute cloud user/final scripts.
    [[0;32m  OK  [0m] Reached target Cloud-init target.

    Ubuntu 16.04.1 LTS test ttyS0

    instancename login:

Error messages such as failing to find a disk, file system errors, or syntax
errors in config files will also generally display there.  These type errors
are more difficult to fix without creating a new instance, however a ticket
to support to give options is recommended.

Check the instance log for network errors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On the same Log page as above, click the "Show Full Log".  This opens a new
browser tab with the full available console log output.  Doing a text search
for "eth" or "ens" or cloud-init.  Some problems could include not finding a
network device, or if a snapshot was used the network not being re-configured.

Compare the output of cloud-init network configuration, if available, to the
assigned IPv4 and IPv6 addresses of the instance.  An example output snippet
for Ubuntu 16 looks like so (some timestamps removed for readability):

.. code-block:: console

    Starting Initial cloud-init job (metadata service crawler)...
    cloud-init[982]: Cloud-init v. 0.7.8 running 'init' at Tue, 24 Jan 2017 21:32:28 +0000. Up 8.86 seconds.
    cloud-init[982]: ci-info: ++++++++++++++++++++++++++++++++++++++Net device info+++++++++++++++++++++++++++++++++++++++
    cloud-init[982]: ci-info: +--------+------+------------------------------+---------------+-------+-------------------+
    cloud-init[982]: ci-info: | Device |  Up  |           Address            |      Mask     | Scope |     Hw-Address    |
    cloud-init[982]: ci-info: +--------+------+------------------------------+---------------+-------+-------------------+
    cloud-init[982]: ci-info: |  ens3  | True |        208.113.165.36        | 255.255.252.0 |   .   | fa:16:3e:a5:4c:1c |
    cloud-init[982]: ci-info: |  ens3  | True | fe80::f816:3eff:fea5:4c1c/64 |       .       |  link | fa:16:3e:a5:4c:1c |

This example instance has an IPv4 address of 208.113.165.36.  Confirm this is
the assigned address on the DreamCompute dashboard instances page.

Check security group rules
~~~~~~~~~~~~~~~~~~~~~~~~~~

Back to the `Instances <https://iad2.dreamcompute.com/project/instances/>`_ page,
click the right drop-down menu and select "Edit Security Groups".  Confirm the
necessary security groups are in the right "Instance Security Groups" list.
Make a note of the list of security groups to check next.

On the Access & Security -> `Security Groups <https://iad2.dreamcompute.com/project/access_and_security/?tab=access_security_tabs__security_groups_tab>`_
page, check that the security group(s) assigned to the instance have the ports
open that are being checked.  To do this, click on "Manage Rules" to see the
list of rules.  All instances should have rules for unrestricted egress
(outbound) traffic like so:

.. code-block:: console

    Egress	IPv6	Any	Any	::/0	-
    Egress	IPv4	Any	Any	0.0.0.0/0	-

The other default rules that DreamHost puts in the "default" security group
allow for ping (ICMP), SSH (port 22), HTTP (port 80) and HTTPS (port 443):

.. code-block:: console

    Ingress	IPv6	 58	Any	::/0	-
    Ingress	IPv4	ICMP	Any	0.0.0.0/0	-
    Ingress	IPv6	TCP	22 (SSH)	::/0	-
    Ingress	IPv4	TCP	22 (SSH)	0.0.0.0/0	-
    Ingress	IPv6	TCP	80 (HTTP)	::/0	-
    Ingress	IPv4	TCP	80 (HTTP)	0.0.0.0/0	-
    Ingress	IPv6	TCP	443 (HTTPS)	::/0	-
    Ingress	IPv4	TCP	443 (HTTPS)	0.0.0.0/0	-

If any of these rules are missing, consider adding them to restore the default
functionality.  Sometimes the "allow everything" of IPv4 0.0.0.0/0 and IPv6
::/0 is modified to allow just specific IP blocks.  If so, confirm the IP
range is sufficient for the connectivity desired.

Try a reboot, just in case
~~~~~~~~~~~~~~~~~~~~~~~~~~

It is preferred to find the cause of an issue before blindly reboot an
instance, however the guide is nearing the end and it is now worth a try.  If
it fixes the issue, include the previously gathered console logs for support if
a support ticket is opened.

Consider changes made before the issues
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lastly, if all the above seems correct but there are still issues, consider
what changes were last made before the issue.  Some examples of changes that
can cause issues are additional firewalls, doing large system upgrades that
could modify kernels or network systems, or modifying config files that could
disrupt the boot process if a program won't start.

Conclusion
~~~~~~~~~~

Should there be no other indication of issues in the above logs and
configurations, please `contact support <https://panel.dreamhost.com/index.cgi?tree=support.msg&>`_
with all available info and we will get back to you wish our findings.

.. meta::
    :labels: dreamcompute

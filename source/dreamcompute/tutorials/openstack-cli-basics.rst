==================================================
Getting started with OpenStack command line client
==================================================

Installation
~~~~~~~~~~~~

The OpenStack command line client can be installed in several ways, the best
way is to use `pip` in a virtualenv using the following:

.. code-block:: console

    [user@localhost]$ virtualenv venv -p /usr/bin/python
    [user@localhost]$ source venv/bin/activate
    [user@localhost]$ pip install python-openstackclient

This installs the client in a virtual environment separated from the rest of
your system. In order to be able to use the client you will have to activate
the virtual environment using the source command above.

Configuration
~~~~~~~~~~~~~

The easiest way to configure the client is to use the OpenRC file. Read about
what that is and how to download it in `the tutorial on how to use the OpenRC
file <228047207-How-to-download-your-DreamCompute-openrc-file>`__.

In order to use the OpenRC file, run:

.. code-block:: console

    [user@localhost]$ source openrc.sh

Basic commands
~~~~~~~~~~~~~~

The OpenStack command line client combines the functionality of all of the
other OpenStack service specific command line clients, such as the nova client
and the cinder client. Here are some basic commands that are useful:

.. code-block:: console

    [user@localhost]$ openstack server list
    +--------------------------------------+-------------+--------+--------------------------------------------------------------+--------------+
    | ID                                   | Name        | Status | Networks                                                     | Image Name   |
    +--------------------------------------+-------------+--------+--------------------------------------------------------------+--------------+
    | 4c40d015-33b3-4bc3-ba50-d794356eef4f | mariadb     | ACTIVE | public=2607:f298:5:101d:f816:3eff:feeb:ca8c, 208.113.133.156 | Ubuntu-16.04 |
    | bf500ff3-7b37-4d01-a77e-5efc086de5f0 | nextcloud-1 | ACTIVE | public=2607:f298:5:101d:f816:3eff:fef1:9c6a, 208.113.131.81  | Ubuntu-16.04 |
    | af01d391-7604-482e-84b9-3ccee872d69f | nextcloud   | ACTIVE | public=2607:f298:5:101d:f816:3eff:fea9:a69f, 208.113.129.184 | Ubuntu-16.04 |
    | 72c4271b-d447-444c-b5f6-0af401ca14d2 | wordpress   | ACTIVE | public=2607:f298:5:101d:f816:3eff:fe08:54c5, 208.113.133.184 | Ubuntu-16.04 |
    +--------------------------------------+-------------+--------+--------------------------------------------------------------+--------------+

This lists the servers you have in your tennant with some basic information
about them.

.. code-block:: console

    [user@localhost]$ openstack image list
    +--------------------------------------+--------------+--------+
    | ID                                   | Name         | Status |
    +--------------------------------------+--------------+--------+
    | afa49adf-2831-4a00-9c57-afe1624d5557 | CentOS-6     | active |
    | 842c207f-6964-4ed7-a41a-06ec66a7c954 | Ubuntu-14.04 | active |
    | 30a2a55a-2045-4ed8-a605-2d1c1143edd3 | Ubuntu-16.04 | active |
    | 713f2fbc-05c5-491b-9e02-e000861e7b30 | Fedora-24    | active |
    | 5cb9c233-5867-4e47-80a1-9d774f800444 | Debian-7     | active |
    | f84868a5-5261-404a-9c54-ec317ea16b94 | CentOS-7     | active |
    | b105ad3b-7df8-4318-9c3d-4e4fa4cc4563 | Debian-8     | active |
    | b67b74bc-c3a8-4087-9c28-de02161fdedd | CoreOS       | active |
    +--------------------------------------+--------------+--------+

This lists the images available to your tennant.

.. code-block:: console

    [user@localhost]$ openstack volume list
    +--------------------------------------+-----------------------------+-----------+------+---------------------------------+
    | ID                                   | Display Name                | Status    | Size | Attached to                     |
    +--------------------------------------+-----------------------------+-----------+------+---------------------------------+
    | 21cb1ef8-8541-4919-a8e0-2af66e547b03 | db_volume                   | available |   10 |                                 |
    | 2b3ce54e-7445-4d9e-a153-d03b120f1d1a | Meretricious Nibblet Volume | available |   10 |                                 |
    +--------------------------------------+-----------------------------+-----------+------+---------------------------------+

This lists the volumes you have created.

.. code-block:: console

    [user@localhost]$ openstack server create --key-name my_key --image \
    Ubuntu-16.04 --flavor 100 awesome_server
    +--------------------------------------+-----------------------------------------------------+
    | Field                                | Value                                               |
    +--------------------------------------+-----------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                              |
    | OS-EXT-AZ:availability_zone          | iad-2                                               |
    | OS-EXT-STS:power_state               | NOSTATE                                             |
    | OS-EXT-STS:task_state                | scheduling                                          |
    | OS-EXT-STS:vm_state                  | building                                            |
    | OS-SRV-USG:launched_at               | None                                                |
    | OS-SRV-USG:terminated_at             | None                                                |
    | accessIPv4                           |                                                     |
    | accessIPv6                           |                                                     |
    | addresses                            |                                                     |
    | adminPass                            | DCa8su7uHQUR                                        |
    | config_drive                         |                                                     |
    | created                              | 2016-12-02T19:46:41Z                                |
    | flavor                               | gp1.subsonic (100)                                  |
    | hostId                               |                                                     |
    | id                                   | 24c4538d-6607-4546-95b4-49ee9aa4a26a                |
    | image                                | Ubuntu-16.04 (30a2a55a-2045-4ed8-a605-2d1c1143edd3) |
    | key_name                             | my_key                                              |
    | name                                 | awesome_server                                      |
    | os-extended-volumes:volumes_attached | []                                                  |
    | progress                             | 0                                                   |
    | project_id                           |                                                     |
    | properties                           |                                                     |
    | security_groups                      | [{u'name': u'default'}]                             |
    | status                               | BUILD                                               |
    | updated                              | 2016-12-02T19:46:42Z                                |
    | user_id                              |                                                     |
    +--------------------------------------+-----------------------------------------------------+

This creates an Ubuntu 16.04 server with the gp1.subsonic flavor (ID 100), and
uses the key called ``my_key``.

.. meta::
    :labels: openstack openrc

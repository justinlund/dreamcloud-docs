====================================
OpenStack Command Line Client Basics
====================================

Installation
~~~~~~~~~~~~

The OpenStack Command Line Client can be installed in several ways, the best
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

The OpenStack Command Line Client combines the functionality of all of the
other OpenStack service specific command line clients, such as the nova client
and the cinder client. Here are some basic commands that are useful:

.. code-block:: console

    [user@localhost]$ openstack server list

This lists the servers you have in your tennant with some basic information
about them.

.. code-block:: console

    [user@localhost]$ openstack image list

This lists the images available to your tennant.

.. code-block:: console

    [user@localhost]$ openstack volume list

This lists the volumes you have created.

.. meta::
    :labels: openstack openrc

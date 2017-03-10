================================================
Deploying Discourse with Ansible on DreamCompute
================================================

<WHAT IS DISCOURSE GOES HERE>

Prerequisites
~~~~~~~~~~~~~

There are a few prerequisites for setting up Discourse using Ansible:
* Ansible 2.0+ installed in your system
* An SMTP server that you can send emails from
* A clouds.yml file that has your credentials to authenticate to DreamCompute

If you dont have an SMTP server, consider using `SparkPost
<https://www.sparkpost.com/>`_.

Downloading the Ansible playbook
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The first step to installing Discourse using an Ansible playbook is to download
the playbook to use. Do this by running the following:

.. code-block:: console

    [user@localhost]$ git clone https://github.com/squidboylan/discourse-dreamcompute.git

You should now see a discourse-dreamcompute directory, this is what you will
use to deploy discourse, but first you have to do some configuration.

Configuration
~~~~~~~~~~~~~

The ansible playbook has an example configuration file, copy this to the actual
configuration file by running the following:

.. code-block:: console

    [user@localhost]$ cp vars/dreamcompute.yml.example vars/dreamcompute.yml

Now open up the ``vars/dreamcompute.yml`` file in your favorite editor, there
are a few changes you need to make.

* Change auth.cloud to be the name of your cloud configured in your clouds.yml
  file
* Change discourse.hostname to be the DNS record for your new server that will
  be created
* Change discourse.admin_email to be an email you own, this will be the email
  used when you create an admin account
* Change discourse.smtp\_server to be the hostname of your SMTP server
* Change discourse.smtp\_port to be the port of your SMTP server
* Change discourse.smtp\_user to be the username to use to authenticate to your
  SMTP server
* Change discourse.smtp\_password to be the password to use to authenticate to
  your SMTP server
* If you wish to use a Let's Encrypt SSL cert, set
  discourse.lets\_encrypt\_email to your email you wish to use with Let's
  Encrypt
* Change key\_name to be the name of your public key to put on the new server

Running the playbook
~~~~~~~~~~~~~~~~~~~~

Now you are ready to run your playbook. Do this by running the following:

.. code-block:: console

    [user@localhost]$ ansible-playbook site.yml

This will take a while to run, sometimes up to 20 minutes. If you have
configured everything correctly you can visit the new site in a browser and
finish the installation.

.. meta::
    :labels: ansible docker

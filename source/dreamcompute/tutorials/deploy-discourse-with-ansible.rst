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
* Git installed on your local computer

If you dont have an SMTP server take a look at the `recommended email providers
for Discourse.
<https://github.com/discourse/discourse/blob/master/docs/INSTALL-email.md>`_

Downloading the Ansible playbook
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The first step to installing Discourse using an Ansible playbook is to download
the playbook to use. Do this by running the following:

.. code-block:: console

    [user@localhost]$ git clone https://github.com/squidboylan/discourse-dreamcompute.git

You should now see a discourse-dreamcompute directory, which is what you will
use to deploy Discourse, but first you must make some configurations.

Configuration
~~~~~~~~~~~~~

The Ansible playbook has an example configuration file. Copy this to the actual
configuration file by running the following:

.. code-block:: console

    [user@localhost]$ cp vars/dreamcompute.yml.example vars/dreamcompute.yml

Open the ``vars/dreamcompute.yml`` file in your favorite editor, and then make the following
changes:

* Change auth.cloud to be the name of your cloud configured in your clouds.yml
  file
* Change key\_name to be the name of your public key to put on the new server
* Change discourse.hostname to be the DNS record for your new server that will
  be created, the DNS record does not need to exist yet, it will be created
  after the playbook is run
* Change discourse.admin_email to be an email you own, this will be the email
  used to send the confirmation email when you register an admin account
* Change discourse.smtp\_server to be the hostname of your SMTP server
* Change discourse.smtp\_port to be the port of your SMTP server
* Change discourse.smtp\_user to be the username to use to authenticate to your
  SMTP server
* Change discourse.smtp\_password to be the password to use to authenticate to
  your SMTP server
* discourse.smtp\_authentication can be changed to set the kind of SMTP
  authentication to use, if you are unsure, leave this empty
* If you wish to use a Let's Encrypt SSL cert, set
  discourse.lets\_encrypt\_email to your email you wish to use with Let's
  Encrypt

Running the playbook
~~~~~~~~~~~~~~~~~~~~

Now you are ready to run your playbook. Do this by running the following:

.. code-block:: console

    [user@localhost]$ ansible-playbook site.yml

This takes a while to run, and can take up to 20 minutes.

The last thing to do is create a DNS record for your new server. Do this by
following the `documentation on creating DNS records.
<215414867-How-do-I-add-custom-DNS-records->`_

If you have
configured everything correctly,  visit the new site in a browser and
finish the installation.

.. meta::
    :labels: ansible docker

================================
How to Use Arq with DreamObjects
================================

Overview
~~~~~~~~

.. figure:: images/Arq-icon.png

`Arq <https://www.arqbackup.com>`_ is a Mac and Windows app that allows you to
make online backups that support DreamObjects. Arq backups are encrypted with
a password before they're uploaded so your data is protected.

The installation and configuration of Arq varies depending on the operating
system.  Click your operating system below to jump to the proper instructions.

* `Windows <#connecting-with-arq-on-windows>`_
* `Mac <#connecting-with-arq-on-mac>`_

Connecting with Arq on Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


1. Launch Arq:

    .. figure:: images/Arq-1-win.png

        When launching Arq for the first time, you are prompted to
        choose your backup destination type.  Click the 'Other
        S3-Compatible Service' option, and then click **continue**.

2. Enter DreamObject's hostname:

    .. figure:: images/Arq-2-win.png

        For the S3-Compatible Server URL, enter the hostname
        'https://objects-us-west-1.dream.io'. Next ensure that the
        signature version defaults to 'Signature Version 2', and then
        fill in the access and secret keys with the values from the
        DreamHost panel.  Click **continue** to advance to the next
        step.  Read how to find your `DreamObjects Keys`_.

3. Enter a bucket name:

    .. figure:: images/Arq-3-win.png

        Arq will prompt you to enter a new bucket name, or select an
        existing bucket.  Choose the option you want and enter a name
        if necessary, then click **Add** to complete.

4. Set up backups:

    .. figure:: images/Arq-4-win.png

        After your bucket is configured, Arq will ask if you want to
        setup a new backup schedule, or to restore files from this
        bucket (which requires existing backups in your bucket).  Click
        **Set Up Backups**.

5. Encrypt backups:

    .. figure:: images/Arq-5-win.png

        Create an encrypted password for your backup which allows
        additional security for the backup created.

6. Store the encryption password:

    .. figure:: images/Arq-6-win.png

        After you enter an encrypted password, be sure to write down
        the password you created and store it somewhere safe.

7. Choose the folders to backup:

    .. figure:: images/Arq-7-win.png

        On Windows systems, Arq defaults to backing up the entire C:
        drive excluding only the Recycle Bin and the pagefile.sys file.

8. Edit backup suggestions:

    .. figure:: images/Arq-8-win.png

        To add or remove files or folders, click the **Edit backup
        suggestions** button, which will allow you to customize the
        selection.

Arq is now configured to backup your data.


Connecting with Arq on Mac
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Launch Arq

    .. figure:: images/Arq-1-mac.png

        Launch Arq.  When launching Arq for the first time, you are
        prompted to choose your backup destination type.  Select
        'DreamObjects' from the drop-down list.  Fields to enter the
        access and secret keys will appear as well as a button to open
        the DreamHost panel to find your keys.  Enter your desired
        keys.  Read how to find your `DreamObjects Keys`_.

2. Select bucket or create one:

    .. figure:: images/Arq-2-mac.png

        After you enter the DreamObjects access Key and secret Key,
        enter a new bucket name or select an existing bucket from the
        drop down list.

3. Set up backups:

    .. figure:: images/Arq-3-mac.png

        After your bucket is configured, Arq will ask if you want to
        setup a new backup schedule, or to restore files from this
        bucket (which requires existing backups in your bucket).  Click
        **Set Up Backups**.

4. Encrypt backup:

    .. figure:: images/Arq-4-mac.png

        Create an encrypted password for your backup which allows
        additional security for the backup created.

5. Store your password:

    .. figure:: images/Arq-5-mac.png

        After you enter an encrypted password, be sure to write down
        the password you created and store it somewhere safe.

6. Choose the folders to backup:

    .. figure:: images/Arq-6-mac.png

        On Mac systems, Arq defaults to backing up the /Users
        directory, excluding files it knows are unnecessary like cache
        and page files.

7. Edit backup suggestions:

    .. figure:: images/Arq-7-mac.png

        To add or remove files or folders, click the **Edit backup
        suggestions** button, which will allow you to customize the
        selection.

Arq is now configured to backup your data.


.. _DreamObjects Keys: 215986357-What-are-Keys-in-DreamObjects-and-How-Do-You-Use-Them-

.. meta::
    :labels: arq windows mac

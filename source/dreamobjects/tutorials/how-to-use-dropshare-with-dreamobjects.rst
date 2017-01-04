=======================================
How to Use Dropshare with DreamObjects
=======================================

Overview
~~~~~~~~

`Dropshare <https://getdropsha.re>`_ is a so-called menulet for OS X that
enables you to easily drag&drop files, folders and anything else to your own
server, DreamObjects, or other cloud services. Once uploaded, the app copies
the link to the file to your Mac's clipboard and you're ready to share with
anyone you like!

Before you begin, you'll need to create a `bucket`_ on the
`(Panel > 'Cloud Services' > DreamObjects'
<https://panel.dreamhost.com/index.cgi?tree=cloud.objects&>`_) page.

Configure Dropshare
--------------------

1. `Download the latest release from the Dropshare site
   <http://getdropsha.re>`_.
2. Launch Dropshare and click the Dropshare menulet to expand the app. Click
   the gear icon and go to Preferences.

    .. figure:: images/01-dropshare.png

3. Click the 'Connections' menu item in the Preference pane.

    .. figure:: images/02-dropshare.png

4. Delete the default SCP connection then click **Custom S3 API-Compliant
   Connection** to create a DreamObjects connection.

   .. figure:: images/03-dropshare.png

5. Enter your DreamObjects Bucket name, Access and Secret keys. Visit the
   `DreamObjects keys`_ article for details.

   Use **objects-us-west-1.dream.io** for the server. Also be sure to check the
   boxes for **Use SSL** and **Use AWS v2 Signature**.

   .. figure:: images/04-dropshare.png

6. Click the **Test connection** button. This will copy a URL to your
   clipboard.

    .. figure:: images/05-dropshare.png

7. Open a browser window and paste the URL into the address bar. You should
   see the test image below.

    .. figure:: images/06-dropshare.png

8. Return to the Dropshare Preference pane and click the **Save & Close**
   button and close the preference pane. Dropshare is now configured for
   use with your DreamObjects bucket!

   .. figure:: images/07-dropshare.png


.. _DreamObjects keys: 215986357-What-are-Keys-in-DreamObjects-and-How-Do-You-Use-Them-

.. _bucket: 215321178-What-are-Buckets-in-DreamObjects-and-How-Do-You-Use-Them-

.. meta::
    :labels: dropshare macos desktop S3 object

===============================================
How to create static websites with DreamObjects
===============================================

You can configure a DreamObjects bucket to serve static web pages
created with HTML, CSS, and JavaScript. This allows you to host an
entire website that is simple to build and very inexpensive.

Static web pages are usually HTML pages that are served in their
stored form, instead of being built dynamically by a web application
such as WordPress, Django, and similar ones. There are a lot of tools
that help generate and maintain static web pages: the site `StaticGen
<https://www.staticgen.com/>`_ maintains a list of open source static
site generators that you can use to create the files to upload in your
new DreamObjects website bucket.

This tutorial covers how to **serve** a static website from a
DreamObjects bucket, and doesn't cover how to create the files for the
static website itself.

.. note:: Make sure you have a working `installation of S3cmd
          <215916627>`_ before proceeding.

Creating the bucket
-------------------

The name of the bucket must be the same name of the DNS entry. For
example, if your website is www.example.com, name the bucket
`www.example.com`:

.. code-block:: console

    [user@localhost]$ s3cmd mb s3://www.example.com
    Bucket 's3://www.example.com/' created

Creating the website for the bucket
-----------------------------------

Once the bucket is created, use s3cmd to configure the bucket as a
website. The option `ws-create` takes many arguments but for this
example the default index page is configured:

.. code-block:: console

    [user@localhost]$ s3cmd ws-create --ws-index index.html s3://www.example.com
    Bucket 's3://www.example.com/': website configuration created.

You can also configure a default error page, using the `--ws-error`
argument for the `ws-create` command. Read the full `S3cmd man page
<http://manpages.org/s3cmd>`_ for more details.

Check the results of the command with `ws-info` — it should look like
the following example:

.. code-block:: console

    [user@localhost]$ s3cmd ws-info s3://www.example.com
    Bucket s3://www.example.com/: Website configuration
    Website endpoint: http://www.example.com.objects-website-us-west-1.dream.io/
    Index document:   index.html
    Error document:   None

.. note:: s3cmd configuration needs `website_endpoint` set to output
          this value correctly. If you use the default, things will
          still work, but the printed output here will be
          `http://www.example.com.s3-website-us-east-1.amazonaws.com/`.

Setting the policy for the bucket and upload the static files
-------------------------------------------------------------

At this point, the bucket is ready and all you need to do is upload
the HTML files, JavaScript, CSS, images, and any videos you may have
in your static website. From the root folder of your website, upload
these files with the `sync` command, setting the files public `-P` and
recursively `-r`.

.. code-block:: console

     [user@localhost]$ s3cmd -Pr sync . s3://www.example.com

This process takes awhile, depending on the size of your site and the
upload bandwidth. Once it completes, visit the website endpoint with
your browser (in the example,
http://www.example.com.objects-website-us-west-1.dream.io/). You
should see the content of your index.html file.

.. note:: Support for HTTPS will be added soon.

Creating the DNS entry
----------------------

As a last step, you can create a more attractive name for your site,
such as www.example.com. Go to the `Panel -> Domains
<https://panel.dreamhost.com/index.cgi?tree=domain.manage&>`_ and add
a custom DNS record to the domain. Pick `CNAME` and insert
`www.example.com.objects-website-us-west-1.dream.io`.

.. note:: The endpoint for website is
          `objects-website-us-west-1.dream.io` while the API endpoint
          for DreamObjects is `objects-us-west-1.dream.io`.

As soon as DNS information propagates, your site is reachable in your
browser at http://www.example.com.

.. meta::
    :labels: s3cmd staticsite

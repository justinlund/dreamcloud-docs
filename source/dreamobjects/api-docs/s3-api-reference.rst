=========================================
How To Use DreamObjects S3-compatible API
=========================================

.. container:: table_of_content

    - :ref:`RADOS_S3_API`
    - :ref:`Common_Entities_S3`
    - :ref:`Authentication_S3`
    - :ref:`Service_Operations_S3`
    - :ref:`Bucket_Operations_S3`
    - :ref:`Object_Operations_S3`

.. _RADOS_S3_API:

DreamObjects RADOS S3 API
-------------------------

DreamObjects supports the Amazon S3 API, so it’s easy to use your
existing apps, but unlike Amazon, DreamObjects uses RGW, the RADOS
Gateway that is built on the CEPH file store.

Features Supported
~~~~~~~~~~~~~~~~~~

The following table describes the support status for current Amazon S3
functional features:

+------------------------------+---------------+------------------------------+
|  Feature                     |   Status      |    Remarks                   |
+==============================+===============+==============================+
| PUT Bucket (Create Bucket)   | Supported     | Different set of canned ACLs |
+------------------------------+---------------+------------------------------+
| DELETE Bucket                | Supported     |                              |
+------------------------------+---------------+------------------------------+
| GET Bucket (List Objects)    | Supported     |                              |
+------------------------------+---------------+------------------------------+
| GET Bucket ACLs              | Supported     | Different set of canned ACLs |
+------------------------------+---------------+------------------------------+
| PUT Bucket ACLs              | Supported     | Different set of canned ACLs |
+------------------------------+---------------+------------------------------+
| HEAD Bucket (Get Bucket Info)| Supported     |                              |
+------------------------------+---------------+------------------------------+
| Bucket Lifecycle             | Not Supported |                              |
+------------------------------+---------------+------------------------------+
| Bucket Location              | Not Supported |                              |
+------------------------------+---------------+------------------------------+
| Bucket Notification          | Not Supported |                              |
+------------------------------+---------------+------------------------------+
| Bucket Object Versions       | Supported     |                              |
+------------------------------+---------------+------------------------------+
| Bucket Request Payment       | Not Supported |                              |
+------------------------------+---------------+------------------------------+
| Bucket Website               | Supported     |                              |
+------------------------------+---------------+------------------------------+
| Policy (Buckets, Objects)    | Not Supported | ACLs are Supported           |
+------------------------------+---------------+------------------------------+
| PUT Object                   | Supported     |                              |
+------------------------------+---------------+------------------------------+
| DELETE Object                | Supported     |                              |
+------------------------------+---------------+------------------------------+
| GET Object                   | Supported     |                              |
+------------------------------+---------------+------------------------------+
| GET Object ACLs              | Supported     |                              |
+------------------------------+---------------+------------------------------+
| PUT Object ACLs              | Supported     |                              |
+------------------------------+---------------+------------------------------+
| HEAD Object (Get Object Info)| Supported     |                              |
+------------------------------+---------------+------------------------------+
| POST Object                  | Supported     |                              |
+------------------------------+---------------+------------------------------+
| COPY Object                  | Supported     |                              |
+------------------------------+---------------+------------------------------+
| Multipart Uploads            | Supported     |   (missing COPY Part)        |
+------------------------------+---------------+------------------------------+

Unsupported Header Fields
~~~~~~~~~~~~~~~~~~~~~~~~~

The following common request header fields are not supported:

+------------------------+-----------+
| Name                   |    Type   |
+========================+===========+
| x-amz-security-token   |   Request |
+------------------------+-----------+
| Server                 |  Response |
+------------------------+-----------+
| x-amz-delete-marker    |  Response |
+------------------------+-----------+
| x-amz-id-2             |  Response |
+------------------------+-----------+
| x-amz-request-id       |  Response |
+------------------------+-----------+
| x-amz-version-id       |  Response |
+------------------------+-----------+

.. _Common_Entities_S3:

Common Entities
---------------

Bucket and Host Name
~~~~~~~~~~~~~~~~~~~~

There are two different modes of accessing the buckets. The first
(preferred) method identifies the bucket as the top-level directory in
the URI.

::

   GET /mybucket HTTP/1.1
   Host: objects-us-west-1.dream.io

The second method identifies the bucket via a virtual bucket host
name. For example:::

  GET / HTTP/1.1
  Host: mybucket.objects-us-west-1.dream.io

.. note::

   We prefer the first method, because the second method requires
   expensive domain certification and DNS wild cards.


Common Request Headers
~~~~~~~~~~~~~~~~~~~~~~

+--------------------+------------------------------------------+
| Request Header     | Description                              |
+====================+==========================================+
| ``CONTENT_LENGTH`` | Length of the request body.              |
+--------------------+------------------------------------------+
| ``DATE``           | Request time and date (in UTC).          |
+--------------------+------------------------------------------+
| ``HOST``           | The name of the host server.             |
+--------------------+------------------------------------------+
| ``AUTHORIZATION``  | Authorization token.                     |
+--------------------+------------------------------------------+

Common Response Status
~~~~~~~~~~~~~~~~~~~~~~

+---------------+-----------------------------------+
| HTTP Status   | Response Code                     |
+===============+===================================+
| ``100``       | Continue                          |
+---------------+-----------------------------------+
| ``200``       | Success                           |
+---------------+-----------------------------------+
| ``201``       | Created                           |
+---------------+-----------------------------------+
| ``202``       | Accepted                          |
+---------------+-----------------------------------+
| ``204``       | NoContent                         |
+---------------+-----------------------------------+
| ``206``       | Partial content                   |
+---------------+-----------------------------------+
| ``304``       | NotModified                       |
+---------------+-----------------------------------+
| ``400``       | InvalidArgument                   |
+---------------+-----------------------------------+
| ``400``       | InvalidDigest                     |
+---------------+-----------------------------------+
| ``400``       | BadDigest                         |
+---------------+-----------------------------------+
| ``400``       | InvalidBucketName                 |
+---------------+-----------------------------------+
| ``400``       | InvalidObjectName                 |
+---------------+-----------------------------------+
| ``400``       | UnresolvableGrantByEmailAddress   |
+---------------+-----------------------------------+
| ``400``       | InvalidPart                       |
+---------------+-----------------------------------+
| ``400``       | InvalidPartOrder                  |
+---------------+-----------------------------------+
| ``400``       | RequestTimeout                    |
+---------------+-----------------------------------+
| ``400``       | EntityTooLarge                    |
+---------------+-----------------------------------+
| ``403``       | AccessDenied                      |
+---------------+-----------------------------------+
| ``403``       | UserSuspended                     |
+---------------+-----------------------------------+
| ``403``       | RequestTimeTooSkewed              |
+---------------+-----------------------------------+
| ``404``       | NoSuchKey                         |
+---------------+-----------------------------------+
| ``404``       | NoSuchBucket                      |
+---------------+-----------------------------------+
| ``404``       | NoSuchUpload                      |
+---------------+-----------------------------------+
| ``405``       | MethodNotAllowed                  |
+---------------+-----------------------------------+
| ``408``       | RequestTimeout                    |
+---------------+-----------------------------------+
| ``409``       | BucketAlreadyExists               |
+---------------+-----------------------------------+
| ``409``       | BucketNotEmpty                    |
+---------------+-----------------------------------+
| ``411``       | MissingContentLength              |
+---------------+-----------------------------------+
| ``412``       | PreconditionFailed                |
+---------------+-----------------------------------+
| ``416``       | InvalidRange                      |
+---------------+-----------------------------------+
| ``422``       | UnprocessableEntity               |
+---------------+-----------------------------------+
| ``500``       | InternalError                     |
+---------------+-----------------------------------+

.. _Authentication_S3:

How To Authenticate to DreamObjects with S3 API
-----------------------------------------------

Requests to DreamObjects can be either authenticated or unauthenticated.
DreamObjects assumes unauthenticated requests are sent by an anonymous user.
DreamObjects supports canned ACLs.

Authentication
~~~~~~~~~~~~~~

Authenticating a request requires including an access key and a Hash-based
Message Authentication Code (HMAC) in the request before it is sent to the
RGW server. RGW uses an S3-compatible authentication approach.

::

    HTTP/1.1
    PUT /buckets/bucket/object.mpeg
    Host: objects-us-west-1.dream.io
    Date: Mon, 2 Jan 2012 00:01:01 +0000
    Content-Encoding: mpeg
    Content-Length: 9999999

    Authorization: AWS {access-key}:{hash-of-header-and-secret}

In the foregoing example, replace ``{access-key}`` with the value for your access
key ID followed by a colon (``:``). Replace ``{hash-of-header-and-secret}`` with
a hash of the header string and the secret corresponding to the access key ID.

To generate the hash of the header string and secret, you must:

#. Get the value of the header string.
#. Normalize the request header string into canonical form.
#. Generate an HMAC using a SHA-1 hashing algorithm.
   See `RFC 2104`_ and `HMAC`_ for details.
#. Encode the ``hmac`` result as base-64.

To normalize the header into canonical form:

#. Get all fields beginning with ``x-amz-``.
#. Ensure that the fields are all lowercase.
#. Sort the fields lexicographically.
#. Combine multiple instances of the same field name into a
   single field and separate the field values with a comma.
#. Replace white space and line breaks in field values with a single space.
#. Remove white space before and after colons.
#. Append a new line after each field.
#. Merge the fields back into the header.

Replace the ``{hash-of-header-and-secret}`` with the base-64 encoded HMAC string.

.. _RFC 2104: http://www.ietf.org/rfc/rfc2104.txt
.. _HMAC: http://en.wikipedia.org/wiki/HMAC

Understand DreamObjects S3-compatible Access Control List
---------------------------------------------------------

DreamObjects supports S3-compatible Access Control List (ACL)
functionality. An ACL is a list of access grants that specify which
operations a user can perform on a bucket or on an object.  Each grant
has a different meaning when applied to a bucket versus applied to an
object:

+------------------+--------------------------------------------------------+----------------------------------------------+
| Permission       | Bucket                                                 | Object                                       |
+==================+========================================================+==============================================+
| ``READ``         | Grantee can list the objects in the bucket.            | Grantee can read the object.                 |
+------------------+--------------------------------------------------------+----------------------------------------------+
| ``WRITE``        | Grantee can write or delete objects in the bucket.     | N/A                                          |
+------------------+--------------------------------------------------------+----------------------------------------------+
| ``READ_ACP``     | Grantee can read bucket ACL.                           | Grantee can read the object ACL.             |
+------------------+--------------------------------------------------------+----------------------------------------------+
| ``WRITE_ACP``    | Grantee can write bucket ACL.                          | Grantee can write to the object ACL.         |
+------------------+--------------------------------------------------------+----------------------------------------------+
| ``FULL_CONTROL`` | Grantee has full permissions for object in the bucket. | Grantee can read or write to the object ACL. |
+------------------+--------------------------------------------------------+----------------------------------------------+

.. _Service_Operations_S3:

Understand DreamObjects S3-compatible Service Operations
--------------------------------------------------------

List Buckets
~~~~~~~~~~~~

``GET /`` returns a list of buckets created by the user making the
request. ``GET /`` only returns buckets created by an authenticated
user. You cannot make an anonymous request.

Syntax
^^^^^^

::

    GET / HTTP/1.1
    Host: objects-us-west-1.dream.io

    Authorization: AWS {access-key}:{hash-of-header-and-secret}

Response Entities
^^^^^^^^^^^^^^^^^

+----------------------------+-------------+-----------------------------------------------------------------+
| Name                       | Type        | Description                                                     |
+============================+=============+=================================================================+
| ``Buckets``                | Container   | Container for list of buckets.                                  |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``Bucket``                 | Container   | Container for bucket information.                               |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``Name``                   | String      | Bucket name.                                                    |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``CreationDate``           | Date        | UTC time when the bucket was created.                           |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``ListAllMyBucketsResult`` | Container   | A container for the result.                                     |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``Owner``                  | Container   | A container for the bucket owner's ``ID`` and ``DisplayName``.  |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``ID``                     | String      | The bucket owner's ID.                                          |
+----------------------------+-------------+-----------------------------------------------------------------+
| ``DisplayName``            | String      | The bucket owner's display name.                                |
+----------------------------+-------------+-----------------------------------------------------------------+

.. _Bucket_Operations_S3:

Understand DreamObjects S3-compatible Bucket Operations
-------------------------------------------------------

PUT Bucket
~~~~~~~~~~

Creates a new bucket. To create a bucket, you must have a user ID and a valid AWS Access Key ID to authenticate requests. You may not
create buckets as an anonymous user.

.. note:: We do not support request entities for ``PUT /{bucket}`` in this release.

Constraints
^^^^^^^^^^^

In general, bucket names should follow domain name constraints.

- Bucket names must be unique.
- Bucket names must begin and end with a lowercase letter.
- Bucket names may contain a dash (-).

Syntax
^^^^^^

::

    PUT /{bucket} HTTP/1.1
    Host: objects-us-west-1.dream.io
    x-amz-acl: public-read-write

    Authorization: AWS {access-key}:{hash-of-header-and-secret}

Parameters
^^^^^^^^^^

+---------------+----------------------+-----------------------------------------------------------------------------+------------+
| Name          | Description          | Valid Values                                                                | Required   |
+===============+======================+=============================================================================+============+
| ``x-amz-acl`` | Canned ACLs.         | ``private``, ``public-read``, ``public-read-write``, ``authenticated-read`` | No         |
+---------------+----------------------+-----------------------------------------------------------------------------+------------+



HTTP Response
^^^^^^^^^^^^^

If the bucket name is unique, within constraints and unused, the operation will succeed.
If a bucket with the same name already exists and the user is the bucket owner, the operation will succeed.
If the bucket name is already in use, the operation will fail.

+---------------+-----------------------+----------------------------------------------------------+
| HTTP Status   | Status Code           | Description                                              |
+===============+=======================+==========================================================+
| ``409``       | BucketAlreadyExists   | Bucket already exists under different user's ownership.  |
+---------------+-----------------------+----------------------------------------------------------+

DELETE Bucket
~~~~~~~~~~~~~

Deletes a bucket. You can reuse bucket names following a successful bucket removal.

Syntax
^^^^^^

::

    DELETE /{bucket} HTTP/1.1
    Host: objects-us-west-1.dream.io

    Authorization: AWS {access-key}:{hash-of-header-and-secret}

HTTP Response
^^^^^^^^^^^^^

+---------------+---------------+------------------+
| HTTP Status   | Status Code   | Description      |
+===============+===============+==================+
| ``204``       | No Content    | Bucket removed.  |
+---------------+---------------+------------------+

GET Bucket
~~~~~~~~~~

Returns a list of bucket objects.

Syntax
^^^^^^

::

    GET /{bucket}?max-keys=25 HTTP/1.1
    Host: objects-us-west-1.dream.io

Parameters
^^^^^^^^^^

+-----------------+-----------+-----------------------------------------------------------------------+
| Name            | Type      | Description                                                           |
+=================+===========+=======================================================================+
| ``prefix``      | String    | Only returns objects that contain the specified prefix.               |
+-----------------+-----------+-----------------------------------------------------------------------+
| ``delimiter``   | String    | The delimiter between the prefix and the rest of the object name.     |
+-----------------+-----------+-----------------------------------------------------------------------+
| ``marker``      | String    | A beginning index for the list of objects returned.                   |
+-----------------+-----------+-----------------------------------------------------------------------+
| ``max-keys``    | Integer   | The maximum number of keys to return. Default is 1000.                |
+-----------------+-----------+-----------------------------------------------------------------------+


HTTP Response
^^^^^^^^^^^^^

+---------------+---------------+--------------------+
| HTTP Status   | Status Code   | Description        |
+===============+===============+====================+
| ``200``       | OK            | Buckets retrieved  |
+---------------+---------------+--------------------+

Bucket Response Entities
^^^^^^^^^^^^^^^^^^^^^^^^

``GET /{bucket}`` returns a container for buckets with the following fields.

+------------------------+-----------+----------------------------------------------------------------------------------+
| Name                   | Type      | Description                                                                      |
+========================+===========+==================================================================================+
| ``ListBucketResult``   | Entity    | The container for the list of objects.                                           |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``Name``               | String    | The name of the bucket whose contents will be returned.                          |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``Prefix``             | String    | A prefix for the object keys.                                                    |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``Marker``             | String    | A beginning index for the list of objects returned.                              |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``MaxKeys``            | Integer   | The maximum number of keys returned.                                             |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``Delimiter``          | String    | If set, objects with the same prefix will appear in the ``CommonPrefixes`` list. |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``IsTruncated``        | Boolean   | If ``true``, only a subset of the bucket's contents were returned.               |
+------------------------+-----------+----------------------------------------------------------------------------------+
| ``CommonPrefixes``     | Container | If multiple objects contain the same prefix, they will appear in this list.      |
+------------------------+-----------+----------------------------------------------------------------------------------+

Object Response Entities
^^^^^^^^^^^^^^^^^^^^^^^^

The ``ListBucketResult`` contains objects, where each object is within a ``Contents`` container.

+------------------------+-----------+------------------------------------------+
| Name                   | Type      | Description                              |
+========================+===========+==========================================+
| ``Contents``           | Object    | A container for the object.              |
+------------------------+-----------+------------------------------------------+
| ``Key``                | String    | The object's key.                        |
+------------------------+-----------+------------------------------------------+
| ``LastModified``       | Date      | The object's last-modified date/time.    |
+------------------------+-----------+------------------------------------------+
| ``ETag``               | String    | An MD-5 hash of the object. (entity tag) |
+------------------------+-----------+------------------------------------------+
| ``Size``               | Integer   | The object's size.                       |
+------------------------+-----------+------------------------------------------+
| ``StorageClass``       | String    | Should always return ``STANDARD``.       |
+------------------------+-----------+------------------------------------------+


Get Bucket ACL
~~~~~~~~~~~~~~

Retrieves the bucket access control list. The user needs to be the bucket
owner or to have been granted ``READ_ACP`` permission on the bucket.

Syntax
^^^^^^

Add the ``acl`` subresource to the bucket request as shown below.

::

    GET /{bucket}?acl HTTP/1.1
    Host: objects-us-west-1.dream.io

    Authorization: AWS {access-key}:{hash-of-header-and-secret}

Response Entities
^^^^^^^^^^^^^^^^^

+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| Name                      | Type        | Description                                                                                  |
+===========================+=============+==============================================================================================+
| ``AccessControlPolicy``   | Container   | A container for the response.                                                                |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``AccessControlList``     | Container   | A container for the ACL information.                                                         |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Owner``                 | Container   | A container for the bucket owner's ``ID`` and ``DisplayName``.                               |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``ID``                    | String      | The bucket owner's ID.                                                                       |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``DisplayName``           | String      | The bucket owner's display name.                                                             |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grant``                 | Container   | A container for ``Grantee`` and ``Permission``.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grantee``               | Container   | A container for the ``DisplayName`` and ``ID`` of the user receiving a grant of permission.  |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Permission``            | String      | The permission given to the ``Grantee`` bucket.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+

PUT Bucket ACL
~~~~~~~~~~~~~~

Sets an access control to an existing bucket. The user needs to be the bucket
owner or to have been granted ``WRITE_ACP`` permission on the bucket.

Syntax
^^^^^^
Add the ``acl`` subresource to the bucket request as shown below.

::

    PUT /{bucket}?acl HTTP/1.1

Request Entities
^^^^^^^^^^^^^^^^

+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| Name                      | Type        | Description                                                                                  |
+===========================+=============+==============================================================================================+
| ``AccessControlPolicy``   | Container   | A container for the request.                                                                 |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``AccessControlList``     | Container   | A container for the ACL information.                                                         |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Owner``                 | Container   | A container for the bucket owner's ``ID`` and ``DisplayName``.                               |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``ID``                    | String      | The bucket owner's ID.                                                                       |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``DisplayName``           | String      | The bucket owner's display name.                                                             |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grant``                 | Container   | A container for ``Grantee`` and ``Permission``.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grantee``               | Container   | A container for the ``DisplayName`` and ``ID`` of the user receiving a grant of permission.  |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Permission``            | String      | The permission given to the ``Grantee`` bucket.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+

List Bucket Multipart Uploads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``GET /?uploads`` returns a list of the current in-progress multipart uploads--i.e., the application initiates a multipart upload, but
the service hasn't completed all the uploads yet.

Syntax
^^^^^^

::

    GET /{bucket}?uploads HTTP/1.1

Parameters
^^^^^^^^^^

You may specify parameters for ``GET /{bucket}?uploads``, but none of them are required.

+------------------------+-----------+--------------------------------------------------------------------------------------+
| Name                   | Type      | Description                                                                          |
+========================+===========+======================================================================================+
| ``prefix``             | String    | Returns in-progress uploads whose keys contains the specified prefix.                |
+------------------------+-----------+--------------------------------------------------------------------------------------+
| ``delimiter``          | String    | The delimiter between the prefix and the rest of the object name.                    |
+------------------------+-----------+--------------------------------------------------------------------------------------+
| ``key-marker``         | String    | The beginning marker for the list of uploads.                                        |
+------------------------+-----------+--------------------------------------------------------------------------------------+
| ``max-keys``           | Integer   | The maximum number of in-progress uploads. The default is 1000.                      |
+------------------------+-----------+--------------------------------------------------------------------------------------+
| ``max-uploads``        | Integer   | The maximum number of multipart uploads. The range from 1-1000. The default is 1000. |
+------------------------+-----------+--------------------------------------------------------------------------------------+
| ``upload-id-marker``   | String    | Ignored if ``key-marker`` isn't specified. Specifies the ``ID`` of first             |
|                        |           | upload to list in lexicographical order at or following the ``ID``.                  |
+------------------------+-----------+--------------------------------------------------------------------------------------+


Response Entities
^^^^^^^^^^^^^^^^^

+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| Name                                    | Type        | Description                                                                                              |
+=========================================+=============+==========================================================================================================+
| ``ListMultipartUploadsResult``          | Container   | A container for the results.                                                                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``ListMultipartUploadsResult.Prefix``   | String      | The prefix specified by the ``prefix`` request parameter (if any).                                       |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Bucket``                              | String      | The bucket that will receive the bucket contents.                                                        |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``KeyMarker``                           | String      | The key marker specified by the ``key-marker`` request parameter (if any).                               |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``UploadIdMarker``                      | String      | The marker specified by the ``upload-id-marker`` request parameter (if any).                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``NextKeyMarker``                       | String      | The key marker to use in a subsequent request if ``IsTruncated`` is ``true``.                            |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``NextUploadIdMarker``                  | String      | The upload ID marker to use in a subsequent request if ``IsTruncated`` is ``true``.                      |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``MaxUploads``                          | Integer     | The max uploads specified by the ``max-uploads`` request parameter.                                      |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Delimiter``                           | String      | If set, objects with the same prefix will appear in the ``CommonPrefixes`` list.                         |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``IsTruncated``                         | Boolean     | If ``true``, only a subset of the bucket's upload contents were returned.                                |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Upload``                              | Container   | A container for ``Key``, ``UploadId``, ``InitiatorOwner``, ``StorageClass``, and ``Initiated`` elements. |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Key``                                 | String      | The key of the object once the multipart upload is complete.                                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``UploadId``                            | String      | The ``ID`` that identifies the multipart upload.                                                         |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Initiator``                           | Container   | Contains the ``ID`` and ``DisplayName`` of the user who initiated the upload.                            |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``DisplayName``                         | String      | The initiator's display name.                                                                            |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``ID``                                  | String      | The initiator's ID.                                                                                      |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Owner``                               | Container   | A container for the ``ID`` and ``DisplayName`` of the user who owns the uploaded object.                 |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``StorageClass``                        | String      | The method used to store the resulting object. ``STANDARD`` or ``REDUCED_REDUNDANCY``                    |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Initiated``                           | Date        | The date and time the user initiated the upload.                                                         |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``CommonPrefixes``                      | Container   | If multiple objects contain the same prefix, they will appear in this list.                              |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``CommonPrefixes.Prefix``               | String      | The substring of the key after the prefix as defined by the ``prefix`` request parameter.                |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+

.. _Object_Operations_S3:

Understand DreamObjects S3-compatible Object Operations
-------------------------------------------------------

Put Object
~~~~~~~~~~

Adds an object to a bucket. You must have write permissions on the bucket to perform this operation.


Syntax
^^^^^^

::

    PUT /{bucket}/{object} HTTP/1.1

Request Headers
^^^^^^^^^^^^^^^

+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| Name                 | Description                                | Valid Values                                                                  | Required   |
+======================+============================================+===============================================================================+============+
| **content-md5**      | A base64 encoded MD-5 hash of the message. | A string. No defaults or constraints.                                         | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| **content-type**     | A standard MIME type.                      | Any MIME type. Default: ``binary/octet-stream``                               | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| **x-amz-meta-<...>** | User metadata.  Stored with the object.    | A string up to 8kb. No defaults.                                              | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| **x-amz-acl**        | A canned ACL.                              | ``private``, ``public-read``, ``public-read-write``, ``authenticated-read``   | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+


Copy Object
~~~~~~~~~~~

To copy an object, use ``PUT`` and specify a destination bucket and the object name.

Syntax
^^^^^^

::

    PUT /{dest-bucket}/{dest-object} HTTP/1.1
    x-amz-copy-source: {source-bucket}/{source-object}

Request Headers
^^^^^^^^^^^^^^^

+--------------------------------------+-------------------------------------------------+------------------------+------------+
| Name                                 | Description                                     | Valid Values           | Required   |
+======================================+=================================================+========================+============+
| **x-amz-copy-source**                | The source bucket name + object name.           | {bucket}/{obj}         | Yes        |
+--------------------------------------+-------------------------------------------------+------------------------+------------+
| **x-amz-acl**                        | A canned ACL.                                   | ``private``,           | No         |
|                                      |                                                 | ``public-read``,       |            |
|                                      |                                                 | ``public-read-write``, |            |
|                                      |                                                 | ``authenticated-read`` |            |
+--------------------------------------+-------------------------------------------------+------------------------+------------+
| **x-amz-copy-if-modified-since**     |  Copies only if modified since the timestamp.   |   Timestamp            | No         |
+--------------------------------------+-------------------------------------------------+------------------------+------------+
| **x-amz-copy-if-unmodified-since**   |  Copies only if unmodified since the timestamp. |   Timestamp            | No         |
+--------------------------------------+-------------------------------------------------+------------------------+------------+
| **x-amz-copy-if-match**              |  Copies only if object ETag matches ETag.       |   Entity Tag           | No         |
+--------------------------------------+-------------------------------------------------+------------------------+------------+
| **x-amz-copy-if-none-match**         |  Copies only if object ETag doesn't match.      |   Entity Tag           | No         |
+--------------------------------------+-------------------------------------------------+------------------------+------------+

Response Entities
^^^^^^^^^^^^^^^^^

+------------------------+-------------+-----------------------------------------------+
| Name                   | Type        | Description                                   |
+========================+=============+===============================================+
| **CopyObjectResult**   | Container   |  A container for the response elements.       |
+------------------------+-------------+-----------------------------------------------+
| **LastModified**       | Date        |  The last modified date of the source object. |
+------------------------+-------------+-----------------------------------------------+
| **Etag**               | String      |  The ETag of the new object.                  |
+------------------------+-------------+-----------------------------------------------+

Remove Object
~~~~~~~~~~~~~

Removes an object. Requires WRITE permission set on the containing bucket.

Syntax
^^^^^^

::

    DELETE /{bucket}/{object} HTTP/1.1



Get Object
~~~~~~~~~~

Retrieves an object from a bucket within RADOS.

Syntax
^^^^^^

::

    GET /{bucket}/{object} HTTP/1.1

Request Headers
^^^^^^^^^^^^^^^

+---------------------------+------------------------------------------------+--------------------------------+------------+
| Name                      | Description                                    | Valid Values                   | Required   |
+===========================+================================================+================================+============+
| **range**                 | The range of the object to retrieve.           | Range: bytes=beginbyte-endbyte | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-modified-since**     | Gets only if modified since the timestamp.     | Timestamp                      | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-unmodified-since**   | Gets only if not modified since the timestamp. | Timestamp                      | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-match**              | Gets only if object ETag matches ETag.         | Entity Tag                     | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-none-match**         | Gets only if object ETag matches ETag.         | Entity Tag                     | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+

Response Headers
^^^^^^^^^^^^^^^^

+-------------------+--------------------------------------------------------------------------------------------+
| Name              | Description                                                                                |
+===================+============================================================================================+
| **Content-Range** | Data range, will only be returned if the range header field was specified in the request   |
+-------------------+--------------------------------------------------------------------------------------------+

Get Object Info
~~~~~~~~~~~~~~~

Returns information about object. This request will return the same
header information as with the Get Object request, but will include
the metadata only, not the object data payload.

Syntax
^^^^^^

::

    HEAD /{bucket}/{object} HTTP/1.1

Request Headers
^^^^^^^^^^^^^^^

+---------------------------+------------------------------------------------+--------------------------------+------------+
| Name                      | Description                                    | Valid Values                   | Required   |
+===========================+================================================+================================+============+
| **range**                 | The range of the object to retrieve.           | Range: bytes=beginbyte-endbyte | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-modified-since**     | Gets only if modified since the timestamp.     | Timestamp                      | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-unmodified-since**   | Gets only if not modified since the timestamp. | Timestamp                      | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-match**              | Gets only if object ETag matches ETag.         | Entity Tag                     | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+
| **if-none-match**         | Gets only if object ETag matches ETag.         | Entity Tag                     | No         |
+---------------------------+------------------------------------------------+--------------------------------+------------+

Get Object ACL
~~~~~~~~~~~~~~

Syntax
^^^^^^

::

    GET /{bucket}/{object}?acl HTTP/1.1

Response Entities
^^^^^^^^^^^^^^^^^

+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| Name                      | Type        | Description                                                                                  |
+===========================+=============+==============================================================================================+
| ``AccessControlPolicy``   | Container   | A container for the response.                                                                |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``AccessControlList``     | Container   | A container for the ACL information.                                                         |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Owner``                 | Container   | A container for the object owner's ``ID`` and ``DisplayName``.                               |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``ID``                    | String      | The object owner's ID.                                                                       |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``DisplayName``           | String      | The object owner's display name.                                                             |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grant``                 | Container   | A container for ``Grantee`` and ``Permission``.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grantee``               | Container   | A container for the ``DisplayName`` and ``ID`` of the user receiving a grant of permission.  |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Permission``            | String      | The permission given to the ``Grantee`` object.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+

Set Object ACL
~~~~~~~~~~~~~~

Syntax
^^^^^^

::

    PUT /{bucket}/{object}?acl

Request Entities
^^^^^^^^^^^^^^^^

+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| Name                      | Type        | Description                                                                                  |
+===========================+=============+==============================================================================================+
| ``AccessControlPolicy``   | Container   | A container for the response.                                                                |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``AccessControlList``     | Container   | A container for the ACL information.                                                         |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Owner``                 | Container   | A container for the object owner's ``ID`` and ``DisplayName``.                               |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``ID``                    | String      | The object owner's ID.                                                                       |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``DisplayName``           | String      | The object owner's display name.                                                             |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grant``                 | Container   | A container for ``Grantee`` and ``Permission``.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Grantee``               | Container   | A container for the ``DisplayName`` and ``ID`` of the user receiving a grant of permission.  |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+
| ``Permission``            | String      | The permission given to the ``Grantee`` object.                                              |
+---------------------------+-------------+----------------------------------------------------------------------------------------------+



Initiate Multi-part Upload
~~~~~~~~~~~~~~~~~~~~~~~~~~

Initiate a multi-part upload process.

Syntax
^^^^^^

::

    POST /{bucket}/{object}?uploads

Request Headers
^^^^^^^^^^^^^^^

+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| Name                 | Description                                | Valid Values                                                                  | Required   |
+======================+============================================+===============================================================================+============+
| **content-md5**      | A base64 encoded MD-5 hash of the message. | A string. No defaults or constraints.                                         | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| **content-type**     | A standard MIME type.                      | Any MIME type. Default: ``binary/octet-stream``                               | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| **x-amz-meta-<...>** | User metadata.  Stored with the object.    | A string up to 8kb. No defaults.                                              | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+
| **x-amz-acl**        | A canned ACL.                              | ``private``, ``public-read``, ``public-read-write``, ``authenticated-read``   | No         |
+----------------------+--------------------------------------------+-------------------------------------------------------------------------------+------------+


Response Entities
^^^^^^^^^^^^^^^^^

+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| Name                                    | Type        | Description                                                                                              |
+=========================================+=============+==========================================================================================================+
| ``InitiatedMultipartUploadsResult``     | Container   | A container for the results.                                                                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Bucket``                              | String      | The bucket that will receive the object contents.                                                        |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Key``                                 | String      | The key specified by the ``key`` request parameter (if any).                                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``UploadId``                            | String      | The ID specified by the ``upload-id`` request parameter identifying the multipart upload (if any).       |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+


Multipart Upload Part
~~~~~~~~~~~~~~~~~~~~~

Syntax
^^^^^^

::

    PUT /{bucket}/{object}?partNumber=&uploadId= HTTP/1.1

HTTP Response
^^^^^^^^^^^^^

The following HTTP response may be returned:

+---------------+----------------+--------------------------------------------------------------------------+
| HTTP Status   | Status Code    | Description                                                              |
+===============+================+==========================================================================+
| **404**       | NoSuchUpload   | Specified upload-id does not match any initiated upload on this object   |
+---------------+----------------+--------------------------------------------------------------------------+

List Multipart Upload Parts
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Syntax
^^^^^^

::

    GET /{bucket}/{object}?uploadId=123 HTTP/1.1

Response Entities
^^^^^^^^^^^^^^^^^

+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| Name                                    | Type        | Description                                                                                              |
+=========================================+=============+==========================================================================================================+
| ``InitiatedMultipartUploadsResult``     | Container   | A container for the results.                                                                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Bucket``                              | String      | The bucket that will receive the object contents.                                                        |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Key``                                 | String      | The key specified by the ``key`` request parameter (if any).                                             |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``UploadId``                            | String      | The ID specified by the ``upload-id`` request parameter identifying the multipart upload (if any).       |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Initiator``                           | Container   | Contains the ``ID`` and ``DisplayName`` of the user who initiated the upload.                            |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``ID``                                  | String      | The initiator's ID.                                                                                      |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``DisplayName``                         | String      | The initiator's display name.                                                                            |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Owner``                               | Container   | A container for the ``ID`` and ``DisplayName`` of the user who owns the uploaded object.                 |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``StorageClass``                        | String      | The method used to store the resulting object. ``STANDARD`` or ``REDUCED_REDUNDANCY``                    |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``PartNumberMarker``                    | String      | The part marker to use in a subsequent request if ``IsTruncated`` is ``true``. Precedes the list.        |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``NextPartNumberMarker``                | String      | The next part marker to use in a subsequent request if ``IsTruncated`` is ``true``. The end of the list. |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``MaxParts``                            | Integer     | The max parts allowed in the response as specified by the ``max-parts`` request parameter.               |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``IsTruncated``                         | Boolean     | If ``true``, only a subset of the object's upload contents were returned.                                |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Part``                                | Container   | A container for ``Key``, ``Part``, ``InitiatorOwner``, ``StorageClass``, and ``Initiated`` elements.     |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``PartNumber``                          | Integer     | The identification number of the part.                                                                   |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``ETag``                                | String      | The part's entity tag.                                                                                   |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+
| ``Size``                                | Integer     | The size of the uploaded part.                                                                           |
+-----------------------------------------+-------------+----------------------------------------------------------------------------------------------------------+



Complete Multipart Upload
~~~~~~~~~~~~~~~~~~~~~~~~~

Assembles uploaded parts and creates a new object, thereby completing a multipart upload.

Syntax
^^^^^^

::

    POST /{bucket}/{object}?uploadId= HTTP/1.1

Request Entities
^^^^^^^^^^^^^^^^

+----------------------------------+-------------+-----------------------------------------------------+----------+
| Name                             | Type        | Description                                         | Required |
+==================================+=============+=====================================================+==========+
| ``CompleteMultipartUpload``      | Container   | A container consisting of one or more parts.        | Yes      |
+----------------------------------+-------------+-----------------------------------------------------+----------+
| ``Part``                         | Container   | A container for the ``PartNumber`` and ``ETag``.    | Yes      |
+----------------------------------+-------------+-----------------------------------------------------+----------+
| ``PartNumber``                   | Integer     | The identifier of the part.                         | Yes      |
+----------------------------------+-------------+-----------------------------------------------------+----------+
| ``ETag``                         | String      | The part's entity tag.                              | Yes      |
+----------------------------------+-------------+-----------------------------------------------------+----------+


Response Entities
^^^^^^^^^^^^^^^^^

+-------------------------------------+-------------+-------------------------------------------------------+
| Name                                | Type        | Description                                           |
+=====================================+=============+=======================================================+
| **CompleteMultipartUploadResult**   | Container   | A container for the response.                         |
+-------------------------------------+-------------+-------------------------------------------------------+
| **Location**                        | URI         | The resource identifier (path) of the new object.     |
+-------------------------------------+-------------+-------------------------------------------------------+
| **Bucket**                          | String      | The name of the bucket that contains the new object.  |
+-------------------------------------+-------------+-------------------------------------------------------+
| **Key**                             | String      | The object's key.                                     |
+-------------------------------------+-------------+-------------------------------------------------------+
| **ETag**                            | String      | The entity tag of the new object.                     |
+-------------------------------------+-------------+-------------------------------------------------------+

Abort Multipart Upload
~~~~~~~~~~~~~~~~~~~~~~

Syntax
^^^^^^

::

    DELETE /{bucket}/{object}?uploadId= HTTP/1.1

.. meta::
    :labels: S3 bucket object authentication

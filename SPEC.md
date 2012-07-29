========
Project Specification
========

##General requirements:

* Code must be:
   * Clean. Visual appeal in the source code is a must.
   * Efficient. This must have a small footprint.
   * Readable. Simplicity is favored over cleverness. Be as explicit as possible and use apropos variable names. Comments should be added at the discretion of the programmer to make something clear if it is not thought to be clear enough.
   * Modular. Each function should be as small as possible, drawing on features from other functions. Building blocks.
* Functionality should be generally in line with the community's needs.

##Specific requirements:

* The project may grow to use one of several databases for the backend, such as MySQL, PostgreSQL, SQLite, or MongoDB.
* **All client input used in SQL lookups must be sanitized**
* The current table layout is below. Naturally, this mapping can be easily extended.

<pre>
+---------------------------------------------------------------------------------------------------------------------+
|                                                      torrents                                                       |
+-----+----------------------------------------------------------+----------------------------------------------------+
| oid |                    name (text)                           |                   url (text)                       |
+-----+----------------------------------------------------------+----------------------------------------------------+
|   1 | Fuduntu-2012.3-i686-LiveDVD.iso                          | Fuduntu-2012.3-i686-3671410625.torrent             |
|   2 | David.Arnold-Michael.Price-Sherlock-Series.One.2012.FLAC | Sherlock-Series-One-Soundtrack-(2012)-FLAC.torrent |
+-----+----------------------------------------------------------+----------------------------------------------------+


+------------------+
|       tags       |
+-----+------------+
| oid | tag (text) |
+-----+------------+
|   1 | fuduntu    |
|   2 | os         |
|   3 | linux      |
|   4 | ubuntu     |
|   5 | david      |
|   6 | arnold     |
|   7 | michael    |
|   8 | price      |
|   9 | soundtrack |
|  10 | sherlock   |
|  11 | bbc        |
+-----+------------+


+-----------------------------+
|                map          |
+-----+-----+-----+-----------+
| oid | tag (int) | url (int) |
+-----+-----------+-----------+
|   1 |   1       |   1       |
|   2 |   2       |   1       |
|   3 |   3       |   1       |
|   4 |   4       |   1       |
|   5 |   5       |   2       |
|   6 |   6       |   2       |
|   7 |   7       |   2       |
|   8 |   8       |   2       |
|   9 |   9       |   2       |
|  10 |  10       |   2       |
|  11 |  11       |   2       |
+-----+-----------+-----------+
</pre>

## Abstract Module API Specification:

* Certain sections of webpages (torrent listing page, torrent details page, etc.) can be added to but not modified. For instance, a popularity module would have the ability to append its popularity rating for a torrent on a torrent's details page.
* SQL tables may be added. Only the tables that belong to the module (read: only the tables that the module and the module alone created) can be modified by the module.
* Hooks will be provided for yet-to-be-specified functions of *indexer*.
* A file containing a list of installed modules can be modified by the user to specify which modules have precedence (which one gets access to the hook first, which field on a webpage comes first, etc.) More fine-grained control (individual access ordering: one module gets first pick on webpages but last in SQL access) may eventually be added.

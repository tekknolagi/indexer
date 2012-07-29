========
Installation
========

It's pretty simple.

Requirements:

* rubygems
  * bundler

Then just run `bundle install`

Usage:

* To start the server (and create all necessary files and folders), run:	
    `rackup -o 0.0.0.0 -p 3000`

========
Project Specification
========

##General requirements:

* Code must be:
   * Clean. Visual appeal in the source code is a must.
   * Efficient. This must have a small footprint.
   * Self-documenting. It must be readable enough that it needs no comments. Function and variable names must be clear.
   * Modular. Each function should be as small as possible, drawing on features from other functions. Building blocks.
   * In line with the general "feel" of the rest of the project.
* Functionality should be generally in line with the community's needs.
* Get somebody else to look your code over before submitting a pull request.

##Specific requirements:

* The project may grow to use one of several databases for the backend, such as MySQL, PostgreSQL, SQLite, or MongoDB.
* The current table layout is below. Naturally, this mapping can be easily extended.
<pre>
+-----------------------------------------------------------------------------------------------------------------------+
|                                                      torrents                                                         |
+-----+----------------------------------------------------------+------------------------------------------------------+
| oid |                           name                           |                         url                          |
+-----+----------------------------------------------------------+------------------------------------------------------+
|   1 | Fuduntu-2012.3-i686-LiveDVD.iso                          | Fuduntu-2012.3-i686-3671410625.torrent               |
|   2 | David.Arnold-Michael.Price-Sherlock-Series.One.2012.FLAC | Sherlock-Series-One-Soundtrack-(2012)-FLAC.torrent |
+-----+----------------------------------------------------------+------------------------------------------------------+
</pre>
<pre>
+------------------+
|       tags       |
+-----+------------+
| oid |    tag     |
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
</pre>
<pre>
+-----------------+
|      tagmap     |
+-----+-----+-----+
| oid | tag | url |
+-----+-----+-----+
|   1 |   1 |   1 |
|   2 |   2 |   1 |
|   3 |   3 |   1 |
|   4 |   4 |   1 |
|   5 |   5 |   2 |
|   6 |   6 |   2 |
|   7 |   7 |   2 |
|   8 |   8 |   2 |
|   9 |   9 |   2 |
|  10 |  10 |   2 |
|  11 |  11 |   2 |
+-----+-----+-----+
</pre>
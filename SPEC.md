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
Table: torrents
Column 1: id, INT
Column 2: name, VARCHAR
Column 3: url, VARCHAR

Table: tags
Column 1: id, INT
Column 2: tag, CHAR([tag length limit])

Table: map
Column 1: tag_id, INT
Column 2: torrent_id, INT
</pre>

Given a torrent to find the tags of, the syntax would be:
<pre>SELECT tag_id FROM map WHERE torrent_id = [torrent_id];</pre>
and vice-versa would be:
<pre>SELECT torrent_id FROM map WHERE tag_id = [tag_id];</pre>

## Abstract Module API Specification:

* Certain sections of webpages (torrent listing page, torrent details page, etc.) can be added to but not modified. For instance, a popularity module would have the ability to append its popularity rating for a torrent on a torrent's details page.
* SQL tables may be added. Only the tables that belong to the module (read: only the tables that the module and the module alone created) can be modified by the module.
* Hooks will be provided for yet-to-be-specified functions of *indexer*.
* A file containing a list of installed modules can be modified by the user to specify which modules have precedence (which one gets access to the hook first, which field on a webpage comes first, etc.) More fine-grained control (individual access ordering: one module gets first pick on webpages but last in SQL access) may eventually be added.
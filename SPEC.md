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
* The current table layout is below. Naturally, this mapping can be easily extended.

<pre>
Table: torrents
Column 1: oid, INT
Column 2: url, TEXT
Column 3: torrent, TEXT
Column 4: magnet, TEXT

Table: tags
Column 1: oid, INT
Column 2: tag, TEXT

Table: map
Column 1: oid, INT
Column 2: tag, INT
Column 3: url, INT
</pre>

## Abstract Module API Specification:

* Certain sections of webpages (torrent listing page, torrent details page, etc.) can be added to but not modified. For instance, a popularity module would have the ability to append its popularity rating for a torrent on a torrent's details page.
* SQL tables may be added. Only the tables that belong to the module (read: only the tables that the module and the module alone created) can be modified by the module.
* Hooks will be provided for yet-to-be-specified functions of *indexer*.
* A file containing a list of installed modules can be modified by the user to specify which modules have precedence (which one gets access to the hook first, which field on a webpage comes first, etc.) More fine-grained control (individual access ordering: one module gets first pick on webpages but last in SQL access) may eventually be added.

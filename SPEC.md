========
Spec
========

###Technical

1. Must be written in Ruby.
2. Must use DataMapper as an ORM.
3. Code must be reasonably segmented.
4. Code must be self-documenting.

###Aesthetic

1. Product should be simple.
2. Product should be decent-looking.
3. Product must be usable by nearly everybody.

###Use Cases

1. User wishes to download a movie/other media, and will be able to search for/find an appropriate magnet
link on this website. He can then use a client such as BitTorrent to fetch data from multiple people 
seeding the file, allowing multiple-person sharing.

2. User wishes to release his content in a quick fashion, and as such, uses the site to upload a .torrent 
file, which is then deleted after a magnet link is ripped from it. The user can then use the magnet link 
as a quick and easy way to share and distribute his content to people, as long as there are seeders.

3. User wishes to use an open source system to do his uploading and downloading safely, using a new system
for login, which uses his favorite torrent to influence the exclusive password system, which salts the 
password with the torrent's hash.

###Functionality

1. User is able to upload his .torrent file, out of which, a magnet link will be taken, and then the 
original file deleted. User will also be able to download all the torrent files availible on the site 
via the aforementioned magnet links, allowing widespread sharing.

2. User is able to upload torrents and share them using seed functionality, allowing the user a fast, 
efficient way to share his content, be it music, movies, or any other form of media.

3. User is able to search through the many torrents on the site, influenced by a tag system that will 
aid in finding exactly what the user wants when he inputs his request to the site.

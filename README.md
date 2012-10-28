========
Installation
========

It's pretty simple.

Requirements:

* rubygems
  * bundler

Then just run `bundle install`

Usage:

* Put your DataMapper setup line in `dbconfig.rb`
* To start the server (and create all necessary files and folders), run:	
    `rackup -p 8080 indexer.rb` or use it as a Passenger app (like I am).

========
Contributors
========

* Max Bernstein - author and primary contributor
* Christopher Hinstorff - database structure
* blazes816 of FreeNode - primary debugger
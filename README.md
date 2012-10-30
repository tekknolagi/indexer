========
About
========

This is Brightswipe. It's a torrent indexer - at least for now; DHT functionality is on the way.

The app hosted at brightswipe.com will be going private soon, and will start off exclusive to my school. I hope to do a Facebook-style expansion from there.

It's written in Ruby, with a MySQL backend.

I wrote it keeping everything in `SPEC.md` in mind, and the project should stay that way.

Thanks for checking in,
Max

=========
Installation
=========

It's pretty simple.

Requirements:

* rubygems
  * bundler

Then just run `bundle install`

Usage:

* Put your DataMapper setup line in `dbconfig.rb` - modify `dbconfig_sample.rb`
* To start the server (and create all necessary files and folders), run:	
    `rackup -p 8080 indexer.rb` or use it as a Passenger app (like I am).

========
Contributors
========

* Max Bernstein - author and primary contributor
* Christopher Hinstorff - database structure
* blazes816 of FreeNode - primary debugger
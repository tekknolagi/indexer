require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
require './indexer.rb'

set :environment, :production
set :port, 8080
set :app_file, 'indexer.rb'
disable :run

$upload_dir = 'i'
db_name = "torrents.db"
$torrent_table = "torrents"
$tag_table = "tags"
$map_table = "map"
$allowed_exts = [".torrent"]

$pubdir = File.join('public', $upload_dir)
unless File.directory? 'public'
  Dir.mkdir('public')
end
unless File.directory? $pubdir
  Dir.mkdir($pubdir)
end

unless File.exists? db_name
  $db = SQLite3::Database.new(db_name)
  $db.execute("create table #{$torrent_table} (url text, name text, magnet text)")
  $db.execute("create table #{$tag_table} (tag text)")
  $db.execute("create table #{$map_table} (tag int, url int)")
else
  $db = SQLite3::Database.new(db_name)
end

run Sinatra::Application

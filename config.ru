def sqlite_setup
  require 'sqlite3'
  $sqlite = true
  db_name = $db_name+".db"
  unless File.exists? db_name
    $db = SQLite3::Database.new(db_name)
    $db.execute("create table #{$torrent_table} (url text, name text, magnet text, date text)")
    $db.execute("create table #{$tag_table} (tag text)")
    $db.execute("create table #{$map_table} (tag int, torrent int)")
  else
    $db = SQLite3::Database.new(db_name)
  end
end

configure do
  set :environment, :development
  set :host, "torrent.hypeno.de"
  set :port, "3000"
  
  $upload_dir = 'i'
  $db_name = "torrents"
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
  
  $sql = ARGV.first
  if $sql == 'sqlite'
    sqlite_setup
  else
    $sql = 'sqlite'
    sqlite_setup
  end
end

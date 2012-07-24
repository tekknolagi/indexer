require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
require 'sinatra/reloader'

configure do
  set :port, 8080
  set :environment, :production

  $upload_dir = 'i'
  db_name = "torrents.db"
  $torrent_table = "torrents"
  $tag_table = "tags"
  $map_table = "tagmap"
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
end

def randomize(hash)
  a = 0
  hash[:len] ||= 10
  for i in 1..hash[:len]
    a *= 10
    a += rand(9)
  end
  return hash[:fn]+'_'+a.to_s
end

def build_fn(fn)
  ext = File.extname(fn)
  base = File.basename(fn, '.*')
  return randomize({:fn => base})+ext
end

def split_input(input)
  return input.split /[ *,*;*.*\/*]/
end

def tag_exists?(tag)
  list = $db.execute("select * from #{$tag_table} where tag = ?", tag)
  return list.length > 0
end

def add_tag(tag)
  unless tag_exists? tag
    $db.execute("insert into #{$tag_table} values ( ? )", tag)
  end
  id = $db.execute("select oid from #{$tag_table} where tag = ?", tag)
  return id[0]
end

def add_tags(list)
  list.each {|tag|
    add_tag tag
  }
end

def insert_torrent(fn, name, magnetlink)
  $db.execute("insert into #{$torrent_table} values ( ?, ?, ? )", fn, name, magnetlink)
end

def save_torrent(fn, tmp)
  File.open(File.join('public', $upload_dir, fn), 'w') do |f|
    f.write(tmp .read)
  end
end

def tag_id_by_name(tag)
  return $db.execute("select oid from #{$tag_table} where tag = ?", tag)
end

def torrent_id_by_url(url)
  res = $db.execute("select oid from #{$torrent_table} where url = ?", url)
  return res[0][0]
end

def make_tag_assoc(tag_id, torrent_id)
  $db.execute("insert into #{$map_table} values ( ?, ? )", tag_id, torrent_id)
end

def map_tags_to_torrents(taglist, url)
  torrent_id = torrent_id_by_url url
  taglist.each {|tag|
    tag_id = tag_id_by_name tag
    make_tag_assoc(tag_id, torrent_id)
  }
end

def build_arr(taglist)
  return "( #{taglist.join(', ')} )"
end

def tag_ids_from_names(tags)
  tag_ids = []
  tags.each {|tag|
    tag_ids.push(tag_id_by_name(tag))
  }
  tag_ids.flatten!
  return tag_ids
end

def urls_from_tag_ids(tag_ids)
  urls = []
  url_ids = $db.execute("select url, count(*) num from #{$map_table} where tag in #{build_arr(tag_ids)} group by url having num = #{tag_ids.length}")
  url_ids.flatten.each {|url_id|
    a = $db.execute("select url,name,magnet from #{$torrent_table} where oid = ?", url_id).flatten
    torrent = {
      :url => a[0],
      :name => a[1],
      :magnet => a[2]
    }
    urls.push(torrent)
  }
  return urls.uniq
end

def build_magnet_uri(fn)
  torrent = BEncode.load_file(fn)
  sha1 = OpenSSL::Digest::SHA1.digest(torrent['info'].bencode)
  p = {
    :xt => "urn:btih:" << Base32.encode(sha1),
    :dn => CGI.escape(torrent["info"]["name"])
  }
  Array(torrent["announce-list"]).each do |(tracker, _)|
    p[:tr] ||= []
    p[:tr] << tracker
  end
  magnet_uri  = "magnet:?xt=#{p.delete(:xt)}"
  magnet_uri << "&" << Rack::Utils.build_query(p)
  return magnet_uri
end

def get_torrent_name(fn)
  file = BEncode.load_file(fn)
  return file['info']['name']
end

get '/' do
  erb :index
end

post '/' do
  if params['file']
    @fn = build_fn(params['file'][:filename])
    ext = File.extname(@fn)
    if $allowed_exts.include? ext
      save_torrent(@fn, params['file'][:tempfile])
      name = get_torrent_name(File.join($pubdir,@fn))
      magnetlink = build_magnet_uri(File.join($pubdir, @fn))
      insert_torrent(@fn, name, magnetlink)
      tags = split_input(params['tags'])
      add_tags(tags)
      map_tags_to_torrents(tags, @fn)
      erb :upload
    else
      @error = "Bad file type '#{ext}'"
      erb :error
    end
  else
    @error = "No file uploaded."
    erb :error
  end
end

get '/search' do
  if params['search']
    unless params['search'].strip.gsub(/\s+/, ' ') =~ /^\s*$/
      tags = split_input(params['search'])
      tag_ids = tag_ids_from_names(tags)
      @urls = urls_from_tag_ids(tag_ids)
      erb :list
    else
      @error = "Search query was blank."
      erb :error
    end
  else
    @error = "No search query parameter passed."
    erb :error
  end
end

__END__

@@ index
<title>Torrent Index</title>
<form method='POST' action='/' enctype='multipart/form-data'>
  File: <br><input type='file' name='file' /><br>
  Tags: <br><input type='text' name='tags' /><br>
  <input type='submit' value='Upload' />
</form>
<hr><br>
<form method='GET' action='/search'>
Search: <input type='text' name='search' />
</form>

@@ upload
<title>Uploaded!</title>
<a href='<%= File.join($upload_dir, @fn) %>'><%= @fn %></a>

@@ list
<title>Search Results</title>
<table>
<tr><td>torrent</td><td>magnet</td></tr>
<% if @urls.length > 0 %>
<% @urls.each {|url| %>
<tr>
<td><a href='<%= "#{$upload_dir}/#{url[:url]}" %>'><%= url[:name] %></a></td>
<td><a href='<%= url[:magnet] %>'>magnet</a></td>
</tr>
<% } %>
<% else %>
<tr><td>No torrents match.</td></tr>
<% end %>
</table>

@@ error
<title>Error!</title>
<b>Error:</b> <%= @error %>

configure do
  set :environment, :development
  set :host, "brightswipe.com"
  set :port, "3000"

  $pubdir = 'public/i'

  unless File.directory? 'public'
    Dir.mkdir 'public'
    unless File.directory? $pubdir
      Dir.mkdir $pubdir
    end
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
  ext = File.extname fn
  base = File.basename fn, '.*'
  return randomize(:fn => base)+ext
end

def split_input(input)
  return input.split /[ *,*;*.*\/*]/
end

def tag_exists?(tag)
  list = Tag.all :name => tag
  return list.empty? == false
end

def add_tag(tag)
  unless tag_exists? tag
    tagr = Tag.create :name => tag
    return tagr
  end
  return Tag.first :name => tag
end

def add_tags(list)
  objs = []
  list.each {|tag|
    objs.push(add_tag tag)
  }
  return objs
end

def insert_torrent(rfile, name, magnet, tags)
  tag_objs = add_tags tags
  hash = get_torrent_hash rfile
  t = Torrent.first_or_new({:info_hash => hash}, {:name => name, :magnet => magnet, :created_at => Time.now})
  tag_objs.each {|tag|
    t.tags << tag
  }
  t.save!
end

def save_torrent(fn, tmp)
  File.open(File.join($pubdir, fn), 'w') do |f|
    f.write(tmp.read)
  end
  return File.join($pubdir, fn)
end

def latest_torrents(limit=50, per_page=10, pagenum=1)
  return Torrent.all(:order => [:created_at.desc], :limit => limit).page(pagenum, :per_page => per_page)
end

def torrents_from_tags(tags)
  torrents = []
  tags.each {|tag|
    tago = Tag.all :name => tag
    tagn = Torrent.all :name.like => "%#{tag}%"
    torrents.push tago.torrents
    torrents.push *tagn
  }
  return torrents.flatten.uniq.sort_by {|x| x[:created_at]}.reverse
end

def build_magnet_uri(rfile)
  torrent = BEncode.load_file rfile
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

def get_torrent_name(rfile)
  file = BEncode.load_file rfile
  return file['info']['name']
end

def valid_file?(rfile)
  begin
    BEncode.load_file rfile
  rescue BEncode::DecodeError
    return false
  end
  return true
end

def get_torrent_hash(rfile)
  torrent = BEncode.load_file rfile
  hash = "#{Base32.encode OpenSSL::Digest::SHA1.digest(torrent['info'].bencode)}"
  return hash
end

def get_torrent_rating(t)
  #A la Reddit
  t = DateTime.now.to_i - t[:created_at].to_i
  x = t[:downloads]
  if x > 0
    y = 1
  elsif x == 0
    y = 0
  else
    y = -1
  end
  if Math.abs(x) >= 1
    z = Math.abs(x)
  else
    z = 1
  end
  rating = (Math.log10(z.to_f)+y*t.to_f/45000.0).to_i
  return rating
end

def get_magnet_by_id(id)
  Torrent.first(:id => id)[:magnet]
end

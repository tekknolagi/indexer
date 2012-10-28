configure do
  set :environment, :development
  set :host, "torrent.hypeno.de"
  set :port, "3000"
  
  $upload_dir = 'i'
  $allowed_exts = [".torrent"]
  $pubdir = File.join 'public', $upload_dir

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
  ext = File.extname(fn)
  base = File.basename(fn, '.*')
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

def insert_torrent(url, name, magnet, tags)
  tag_objs = add_tags tags
  t = Torrent.new(
                  :name => name,
                  :url => url,
                  :magnet => magnet,
                  :created_at => DateTime.now
                  )
  tag_objs.each {|tag|
    t.tags << tag
  }
  t.save!
end

def save_torrent(fn, tmp)
  File.open(File.join('public', $upload_dir, fn), 'w') do |f|
    f.write(tmp.read)
  end
end

def latest_torrents(how_many=20)
  return Torrent.all(
                     :order => [:created_at.desc],
                     :limit => how_many
                     )
end

def torrents_from_tags(tags)
  torrents = []
  tags.each {|tag|
    tago = Tag.all :name => tag
    torrents.push tago.torrents
  }
  return torrents.flatten.uniq
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


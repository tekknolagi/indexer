def randomize(fn, len=10)
  a = 0
  for i in 1..len
    a *= 10
    a += rand(9)
  end
  return fn+'_'+a.to_s
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
end

def add_tag(tag)
end

def add_tags(list)
end

def insert_torrent(rfile, name, magnet, tags)
end

def latest_torrents(limit=50, per_page=10, pagenum=1)
end

def torrents_from_tags(tags, limit=20)
end

def get_torrent_rating(t)
end

def get_torrent_by_id(id)
end

def save_torrent(fn, tmp)
  File.open(File.join($pubdir, fn), 'w') do |f|
    f.write(tmp.read)
  end
  return File.join($pubdir, fn)
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

def signup_user(username, pw)
end

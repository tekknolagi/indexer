def randomize(s, len=10)
  s += '_'
  (1..len).each {|i|
    s += rand(9).to_s
  }
  return s
end

def build_fn(fn)
  ext = File.extname fn
  base = File.basename fn, '.*'
  return randomize(base)+ext
end

def split_input(input)
  return input.split /[ *,*;*.*\/*]/
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

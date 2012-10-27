require 'rubygems'
require 'sinatra'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
require 'data_mapper'
require 'dm-mysql-adapter'

load 'torrentdb.rb'
load 'functions.rb'

get '/' do
  erb :index
end

post '/upload' do
  if params['file']
    @url = build_fn params['file'][:filename]
    ext = File.extname @url
    if $allowed_exts.include? ext
      save_torrent @url, params['file'][:tempfile]
      name = get_torrent_name File.join($pubdir,@url)
      magnetlink = build_magnet_uri File.join($pubdir, @url)
      tags = split_input params['tags']
      insert_torrent @url, name, magnetlink, tags
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
      tags = split_input params['search']
      @urls = torrent_urls_from_tags tags
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

get '/new' do
  @torrents = latest_torrents
  @upload_dir = $upload_dir
  erb :list
end

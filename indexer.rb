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
  tempfile = params['torrent'][:tempfile]
  if params['torrent']
    url = build_fn tempfile
    ext = File.extname url
    if $allowed_exts.include? ext
      if valid_file? tempfile
        @name = get_torrent_name File.join($pubdir, tempfile)
        @magnetlink = build_magnet_uri File.join($pubdir, tempfile)
        tags = split_input params['tags']
        insert_torrent name, magnetlink, tags
        erb :index
      else
        @error = "Bad torrent file formatting."
        erb :error
      end
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
  if params['q']
    unless params['q'].strip.gsub(/\s+/, ' ') =~ /^\s*$/
      @query = params['q']
      tags = split_input params['q']
      @torrents = torrents_from_tags tags
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

get '/latest' do
  @torrents = latest_torrents
  @upload_dir = $upload_dir
  erb :list
end

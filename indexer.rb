require 'rubygems'
require 'sinatra'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'pry'

load 'torrentdb.rb'
load 'functions.rb'

get '/' do
  erb :index
end

post '/upload' do
  tempfile = params['torrent'][:tempfile]
  tempfn   = params['torrent'][:filename]
  if params['torrent']
    fn = save_torrent build_fn(tempfn), tempfile
    if valid_file? fn
      @name = get_torrent_name fn
      @magnetlink = build_magnet_uri fn
      tags = split_input params['tags']
      insert_torrent @name, @magnetlink, tags
      FileUtils.rm(fn)
      erb :index
    else
      FileUtils.rm(fn)
      @error = "Bad torrent file formatting."
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

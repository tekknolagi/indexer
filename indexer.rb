require 'rubygems'
require 'sinatra'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'dm-pager'

load 'torrentdb.rb'
load 'functions.rb'

get '/' do
  erb :index
end

post '/upload' do
  if params['torrent']
    tempfile = params['torrent'][:tempfile]
    tempfn   = params['torrent'][:filename]
    fn = save_torrent tempfn, tempfile
    if valid_file? fn
      @name = get_torrent_name fn
      @magnetlink = build_magnet_uri fn
      insert_torrent @name, @magnetlink, split_input(params['tags'])
      FileUtils.rm fn
      erb :index
    else
      @error = "Bad torrent file formatting."
      FileUtils.rm fn
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

get '/latest/?:page?' do
  @torrents = latest_torrents 20, 5, params[:page].to_i
  erb :list
end

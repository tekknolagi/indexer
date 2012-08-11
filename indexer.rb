require 'rubygems'
require 'sinatra'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
load 'config.ru'
load 'functions.rb'

get '/' do
  erb :index
end

post '/' do
  if params['file']
    @url = build_fn(params['file'][:filename])
    ext = File.extname(@url)
    if $allowed_exts.include? ext
      save_torrent(@url, params['file'][:tempfile])
      name = get_torrent_name(File.join($pubdir,@url))
      magnetlink = build_magnet_uri(File.join($pubdir, @url))
      insert_torrent(@url, name, magnetlink)
      tags = split_input(params['tags'])
      add_tags(tags)
      map_tags_to_torrents(tags, @url)
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

get '/new' do
  @urls = []
  latest_torrents.each do |torrent|
    t = {
      :name => torrent[0],
      :url => torrent[1],
      :magnet => torrent[2],
      :date => torrent[3]
    }
    @urls.push(t)
  end
  @upload_dir = $upload_dir
  erb :list
end

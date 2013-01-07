require 'rubygems'
require 'sinatra'
require 'erb'
require 'bencode'
require 'base32'
require 'rack/utils'
require 'cgi'
require 'json'
require 'bcrypt'

load 'torrentdb.rb'
load 'functions.rb'

enable :sessions

class Brightswipe < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/signup' do
    ##Obligatory data validations needed ##
    user = User.new
    user.name = params[:user][:name]
    user.pass_hash = BCrypt::Password.create(params[:user][:password])
    user.save
  end
  
  post '/signin' do
    user = User.first(:email => params[:login][:email].downcase)
    if user && user.authenticate(params[:login][:password])
      session[:user_id] = user.id
    end
    #do a reload here or redirect, flash signin message  
  end

  get '/signout' do
    session[:user_id] = nil
    #flash a message saying signed out, redirect
  end

  post '/upload' do
    if params['torrent']
      tempfile = params['torrent'][:tempfile]
      tempfn   = params['torrent'][:filename]
      fn = save_torrent tempfn, tempfile
      if valid_file? fn
        @name = get_torrent_name fn
        @magnetlink = build_magnet_uri fn
        insert_torrent fn, @name, @magnetlink, split_input(params['tags'])
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

  get '/all' do
    @torrents = Torrent.all :order => :id.desc
    erb :list
  end
  
  get '/latest/?:page?' do
    @torrents = latest_torrents 20, 5, params[:page].to_i
    erb :list
  end  
end

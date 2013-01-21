class Brightswipe < Sinatra::Base
  get '/' do
    erb :index
  end
  
  post '/upload' do
    if params[:torrent]
      tempfile = params[:torrent][:tempfile]
      tempfn   = params[:torrent][:filename]
      fn = save_torrent tempfn, tempfile
      if valid_file? fn
        @name = get_torrent_name fn
        @magnetlink = build_magnet_uri fn
        insert_torrent fn, @name, @magnetlink, split_input(params[:tags])
        FileUtils.rm fn
        erb :index
      else
        @error = true
        @text = "Bad torrent file formatting."
        FileUtils.rm fn
        erb :text
      end
    else
      @error = true
      @text = "No file uploaded."
      erb :text
    end
  end
  
  get '/search' do
    if params[:q]
      unless params[:q].strip.gsub(/\s+/, ' ') =~ /^\s*$/
        @query = params[:q]
        tags = split_input params[:q]
        @torrents = torrents_from_tags tags
        erb :list
      else
        @error = true
        @text = "Search query was blank."
        erb :text
      end
    else
      @error = true
      @text = "No search query parameter passed."
      erb :text
    end
  end

  get '/all' do
    @torrents = []
    @page = 'all'
    erb :list
  end

  get '/about' do
    @text = 'Brightswipe is a <i>torrent indexer</i>.</p><p>This work is licensed under a <a href="http://creativecommons.org/licenses/by-nc/3.0/deed.en_US" target="_blank">Creative Commons Attribution-NonCommercial 3.0 Unported</a> License. For attribution, please clearly mention my name and my website, <a href="http://bernsteinbear.com" target="_blank">Bernstein Bear</a>.'
    erb :text
  end
  
  get '/latest/?:page?' do
    @torrents = []
    @page = 'latest'
    erb :list
  end
end

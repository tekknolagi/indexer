class Brightswipe::API < Brightswipe
  $version = "v0.1"

  configure do
    set :environment, :development
  end

  def api_wrapper(contents)
    wrapper = {
      :version => $version,
      :public => true,
      :contents => contents
    }
    wrapper.to_json
  end

  def error_page(error_text)
    api_wrapper({:error => error_text})
  end

  get '/' do
    'API index page'
  end

  get '/all' do
    api_wrapper(Torrent.all :order => :id.desc)
  end
  
  get '/latest' do
    limit = params[:limit] ? params[:limit].to_i : 20
    page = params[:page] ? params[:page].to_i : 1

    @torrents = latest_torrents limit, 5, page
    api_wrapper(@torrents)
  end

  get '/search' do
    if params[:q]
      api_wrapper(torrents_from_tags(split_input(params[:q]), params[:limit]))
    else
      redirect "/api/latest?limit=#{params[:limit]}"
    end
  end
end

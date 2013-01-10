class Brightswipe::API < Sinatra::Base
  configure do
    set :environment, :development
  end

  get '/' do
    'API index page'
  end

  get '/all' do
    Torrent.all(:order => :id.desc).to_json
  end
  
  get '/latest' do
    limit = params['limit'] ? params['limit'].to_i : 20
    Torrent.all(:order => :id.desc, :limit => limit).to_json
  end

  get '/search' do
    if params['q']
      torrents_from_tags(split_input(params['q']), params['limit']).to_json
    else
      redirect "/api/latest?limit=#{params['limit']}"
    end
  end
end

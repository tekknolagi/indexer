class Brightswipe::API < Sinatra::Base
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
    torrents_from_tags(split_input params['q'], params['limit']).to_json
  end
end

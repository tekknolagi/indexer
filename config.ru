require 'bundler/setup'

configure do
  set :environment, :development
  set :host, "brightswipe.com"
  
  $pubdir = 'public/i'
  
  unless File.directory? 'public'
    Dir.mkdir 'public'
    unless File.directory? $pubdir
      Dir.mkdir $pubdir
    end
  end
end

load 'indexer.rb'
load 'api.rb'
load 'magnet.rb'

run Rack::URLMap.new({
                       "/" => Brightswipe.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

require 'bundler/setup'

load 'indexer.rb'
load 'api.rb'
load 'magnet.rb'

configure do
  set :environment, :development
  set :host, "brightswipe.com"
  set :port, "3000"

  $pubdir = 'public/i'

  unless File.directory? 'public'
    Dir.mkdir 'public'
    unless File.directory? $pubdir
      Dir.mkdir $pubdir
    end
  end
end

run Rack::URLMap.new "/" => Brightswipe.new, "/api" => Brightswipe::API.new, "/magnet" => Brightswipe::Magnet.new
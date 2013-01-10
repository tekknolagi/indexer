require 'bundler/setup'

load 'indexer.rb'
load 'api.rb'
load 'magnet.rb'

run Rack::URLMap.new({
                       "/" => Brightswipe.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

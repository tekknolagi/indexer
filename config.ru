require 'bundler/setup'
load 'lib/indexer.rb'
load 'lib/api.rb'
load 'lib/magnet.rb'

run Rack::URLMap.new({
    "/" => Brightswipe.new,
    "/api" => Brightswipe::API.new,
    "/magnet" => Brightswipe::Magnet.new
    })
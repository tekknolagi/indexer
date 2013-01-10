require 'bundler/setup'

require './indexer.rb'
require './api.rb'
require './magnet.rb'

run Rack::URLMap.new({
                       "/" => Brightswipe.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

require 'bundler/setup'
$LOAD_PATH.unshift(Dir.getwd)
require './indexer'
require './api'
require './magnet'

run Rack::URLMap.new({
                       "/" => Brightswipe.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

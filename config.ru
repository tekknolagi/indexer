require 'bundler/setup'

require './lib/indexer.rb'
require './lib/api.rb'
require './lib/magnet.rb'

configure do
  set :environment, :development

  $pubdir = 'public/i'

  unless File.directory? 'public'
    Dir.mkdir 'public'
    unless File.directory? $pubdir
      Dir.mkdir $pubdir
    end
  end
end

run Rack::URLMap.new({
                       "/" => Brightswipe.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

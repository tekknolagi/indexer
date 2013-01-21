require File.join(File.dirname(__FILE__), 'app.rb')

run Rack::URLMap.new({
                       "/" => Brightswipe.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

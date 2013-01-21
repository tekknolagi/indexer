require File.join(File.dirname(__FILE__), 'app.rb')

run Rack::URLMap.new({
                       "/" => Brightswipe::Main.new,
                       "/api" => Brightswipe::API.new,
                       "/magnet" => Brightswipe::Magnet.new
                     })

require "bundler/setup"

require "rubygems"
require "sinatra"
require "erb"
require "bencode"
require "base32"
require "rack/utils"
require "cgi"
require "json"
require "data_mapper"
require "extensions/all"

require_relative "helpers/init"

require "dm-#{$conf[:server]}-adapter"
require "dm-pager"

require_relative "models/init"

class Brightswipe < Sinatra::Base
  configure do
    enable :run
    set :app_file, __FILE__
    set :views, File.dirname(__FILE__) + '/views'
    set :public_folder, File.dirname(__FILE__) + '/public'
    set :environment, :development

    $pubdir = "public/i"
    unless File.directory? "public"
      Dir.mkdir "public"
      unless File.directory? $pubdir
        Dir.mkdir $pubdir
      end
    end
  end
end

require_relative "lib/init"

configure do
end



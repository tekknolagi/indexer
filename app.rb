require 'bundler/setup'

require "rubygems"
require "sinatra"
require "erb"
require "bencode"
require "base32"
require "rack/utils"
require "cgi"
require "json"

require "data_mapper"

require_relative "helpers/init"

require "dm-#{$conf[:server]}-adapter"
require "dm-pager"

require_relative "models/init"
require_relative "lib/init"

configure do
  set :environment, :development

  $pubdir = "public/i"

  unless File.directory? "public"
    Dir.mkdir "public"
    unless File.directory? $pubdir
      Dir.mkdir $pubdir
    end
  end
end

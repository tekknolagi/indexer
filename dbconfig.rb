load "./values.rb"

=begin
values.rb should have something like this:

$conf = {
  :server => "postgres",
  :user => "user",
  :password => "password",
  :host => "host",
  :database => "database"
}

=end

require "data_mapper"
require "dm-#{$conf[:server]}-adapter"
require "dm-pager"

DataMapper.setup :default, "#{$conf[:server]}://#{$conf[:user]}:#{$conf[:password]}@#{$conf[:host]}/#{$conf[:database]}"

Dir["models/*.rb"].each {|file| load file }

DataMapper.finalize
DataMapper.auto_upgrade!

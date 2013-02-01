$conf = {
  :server => ENV['BRIGHTSWIPE_SERVER'],
  :user => ENV['BRIGHTSWIPE_USER'],
  :password => ENV['BRIGHTSWIPE_PASSWORD'],
  :host => ENV['BRIGHTSWIPE_HOST'],
  :database => ENV['BRIGHTSWIPE_DATABASE']
}

DataMapper.setup :default, "#{$conf[:server]}://#{$conf[:user]}:#{$conf[:password]}@#{$conf[:host]}/#{$conf[:database]}"

DataMapper.finalize
DataMapper.auto_upgrade!

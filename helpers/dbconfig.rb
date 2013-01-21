$conf = {
  :server => "postgres",
  :user => "tdgwdmxmgnvrjy",
  :password => "lgCkKM8w2QvE6mxDJ85BroPq8N",
  :host => "ec2-107-22-170-67.compute-1.amazonaws.com",
  :database => "dcr1848vkguan7"
}

DataMapper.setup :default, "#{$conf[:server]}://#{$conf[:user]}:#{$conf[:password]}@#{$conf[:host]}/#{$conf[:database]}"

DataMapper.finalize
DataMapper.auto_upgrade!

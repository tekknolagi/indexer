require 'json'
require 'net/http'
require 'uri'
load 'torrentdb.rb'

class BrightswipeAdmin
  def clonedb(url)
    uri = URI.parse "http://#{url}/api/all"
    http = Net::HTTP.new uri.host, uri.port
    resp = http.request(Net::HTTP::Get.new uri.request_uri)
    obj = JSON.parse(resp.body.to_s)
    obj.first
  end
end

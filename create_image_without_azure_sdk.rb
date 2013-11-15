require './config'
require 'debugger'

require 'net/http'
require "openssl"
require "base64"
require 'time'


file_name = './tmp/root.vhd'
file = File.new(file_name)

def canonicalized_headers(headers)
  headers = headers.map { |k,v| [k.to_s.downcase, v] }
  headers.select! { |k,v| k =~ /^x-ms-/ }
  headers.sort_by! { |(k,v)| k }
  headers.map! { |k,v| "%s:%s" % [k, v] }
  headers.map! { |h| h.gsub(/\s+/, " ") }.join("\n")
end

def canonicalized_resource(uri)
  resource = "/" + AzureConfig.storage.account + (uri.path.empty? ? "/" : uri.path)
  params = CGI.parse(uri.query.to_s).map { |k,v| [k.downcase, v] }
  params.sort_by! { |k,v| k }
  params.map! { |k,v| "%s:%s" % [k, v.map(&:strip).sort.join(",")] }
  [resource, *params].join("\n")
end


def signable_string(method, uri, headers)
  [
    method.to_s.upcase,
    headers.fetch("Content-MD5", ""),
    headers.fetch("Content-Type", ""),
    headers.fetch("Date") { raise IndexError, "Headers must include Date" },
    canonicalized_headers(headers),
    canonicalized_resource(uri)
  ].join("\n")
end



account = AzureConfig.storage.account
container_name = 'image-container' 
blob_name = 'stemcell-image'


url = "/" + [container_name, blob_name].join('/')

headers = {'Date' => Time.now.httpdate, 'Transfer-Encoding' => 'chunced', 'Content-Length' => file.size}

signed = OpenSSL::HMAC.digest("sha256", AzureConfig.storage.access_key, signable_string(:put, URI.parse(url), headers))
signature = Base64.strict_encode64(signed)



headers.merge!({'Authorization' => "SharedKeyLite #{account}:#{signature}"})


management_endpoint = "https://#{AzureConfig.storage.account}.blob.core.windows.net/" #  AzureConfig.management_endpoint ?


uri  = URI.parse(management_endpoint)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE


management_endpoint_uri = URI.parse(management_endpoint + url[1..-1])
request = Net::HTTP::Put.new(management_endpoint_uri.path)
headers.each_pair { |key, value| request[key] = value }

request.body_stream = File.new(file_name)

response = http.request(request)
puts response.body







# verb = 'PUT'
# content_md5 = ''  
# content_type = ''  # text/plain; charset=UTF-8 ?
# date = Time.now.utc.to_s
# # canonicalized_resource = URI::encode url
# canonicalized_headers  = ms_headers.to_a.map {|pair| "#{pair.first}:#{pair.last}"} 

# string_to_sign = [verb, content_md5, content_type, date, canonicalized_headers, canonicalized_resource].join("\n")

# sha256 = OpenSSL::Digest::SHA256.new
# signed_string = OpenSSL::HMAC.digest(sha256, , string_to_sign)
# signature = Base64.encode64(signed_string)

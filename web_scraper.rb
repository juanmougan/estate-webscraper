require 'open-uri'
require 'nokogiri'
require 'json'

def parse_params
  raise ArgumentError, 'Missing base URL' unless ARGV.size == 1
  return ARGV[0]
end

url = parse_params
html = open(url)

doc = Nokogiri::HTML(html)
puts doc

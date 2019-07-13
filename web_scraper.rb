require 'open-uri'
require 'nokogiri'
require 'json'

# TODO should receive document structure from somewhere instead. Maybe a YAML file?
def parse_params
  raise ArgumentError, 'Missing base URL or search results CSS class' unless ARGV.size == 2
  return ARGV[0], ARGV[1]
end

url, search_results = parse_params
html = open(url)

doc = Nokogiri::HTML(html)
doc.css(".#{search_results}").each do |item|
  # TODO parse everything here. Bear in mind pagination!
  puts item
end

require 'open-uri'
require 'nokogiri'
require 'json'

# Adding some parsing functionality directly into String
class String
  def delete_dollar_sign
    self&.strip&.delete_prefix("$")&.strip
  end
end

# TODO should receive document structure from somewhere instead. Maybe a YAML file?
def parse_params
  raise ArgumentError, 'Missing base URL or search results CSS class or 3 CSS classes' unless ARGV.size == 5
  return ARGV[0], ARGV[1], ARGV[2], ARGV[3], ARGV[4]
end

url, search_results, address_css, price_css, expenses_css = parse_params
html = open(url)

doc = Nokogiri::HTML(html)
doc.css(".#{search_results}").each do |item|				# TODO extract CSS to some config file
  # TODO parse everything here. Bear in mind pagination!
  puts '<!-- Starting item -->'
  puts item
  puts '<!-- End of item -->'
  address = item.at_css(".#{address_css}").text.strip
  puts "Address: #{address}"
  price = item.at_css(".#{price_css}")&.text&.delete_dollar_sign&.tr('.', '')
  # TODO refactor this!
  expenses = item.at_css(".#{expenses_css}")&.text&.strip&.delete_prefix("&amp;plus;")&.strip&.delete_prefix("&plus;")&.delete_dollar_sign&.delete_suffix("expensas")&.strip&.tr('.', '')
  puts "Price: #{price}"
  puts "Expenses: #{expenses}"
end

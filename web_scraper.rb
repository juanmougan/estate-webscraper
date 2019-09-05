require 'open-uri'
require 'nokogiri'
require 'json'
require 'yaml'

# Adding some parsing functionality directly into String
class String
  def delete_dollar_sign
    self&.strip&.delete_prefix("$")&.strip
  end

  def append_slash_then_additional(additional)
    self&.delete_suffix('/') + '/' + additional&.delete_prefix('/')
  end
end

def read_structure
  structure = YAML.load_file('config/structure.yml')
  return structure['base_url'], structure['search_string'], structure['search_results'], 
    structure['address_css'], structure['price_css'], structure['expenses_css']
end

base_url, search_string, search_results, address_css, price_css, expenses_css = read_structure
url = base_url.append_slash_then_additional(search_string)
html = open(url)

doc = Nokogiri::HTML(html)
doc.css(".#{search_results}").each do |item|
  # TODO parse everything here. Bear in mind pagination!
  puts '<!-- Starting item -->'
  puts item
  puts '<!-- End of item -->'
  address = item.at_css(".#{address_css}").text.strip
  puts "Address: #{address}"
  price = item.at_css(".#{price_css}")&.text&.delete_dollar_sign&.tr('.', '')
  relative_link = item.css('a')[0]['href']
  link = base_url.append_slash_then_additional(relative_link)
  puts "Link: #{link}"
  # TODO refactor this!
  expenses = item.at_css(".#{expenses_css}")&.text&.strip&.delete_prefix("&amp;plus;")&.strip&.delete_prefix("&plus;")&.delete_dollar_sign&.delete_suffix("expensas")&.strip&.tr('.', '')
  puts "Price: #{price}"
  puts "Expenses: #{expenses}"
end

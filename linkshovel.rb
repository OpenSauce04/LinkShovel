require 'nokogiri'
require 'open-uri'
require 'set'
require 'bigdecimal'

def get_links(url)
  Nokogiri::HTML(open(url).read).css("a").map do |link|
    if (href = link.attr("href")) && href.match(/^https?:/)
      href
    end
  end.compact
end
puts "Input root website:"
links = Set[gets.chomp]
# Checking link is valid
begin
  link_current=links.to_a.sample
  get_links(link_current)
rescue
  puts "Link is invalid"
  exit
end

for i in 0..BigDecimal::INFINITY
  begin
    puts "\e[H\e[2J"
    puts "LinkShovel"
    puts "‾‾‾‾‾‾‾‾‾‾"
    link_current=links.to_a.sample
    puts "Total sites: "+links.to_a.length.to_s
    puts
    puts "Visiting "+link_current
    puts
    puts "Found: "+get_links(link_current).to_s
    links.merge(get_links(link_current))
    puts
    
    File.open("links.txt", 'w') { |file| file.write(links.to_s) }
  rescue
    next
  end
end

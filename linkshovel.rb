require 'nokogiri'
require 'open-uri'
require 'set'

def get_links(url)
  Nokogiri::HTML(open(url).read).css("a").map do |link|
    if (href = link.attr("href")) && href.match(/^https?:/)
      href
    end
  end.compact
end
puts "Input root website:"
links = Set[gets.chomp]

loop do
  link_current=links.to_a.sample
  puts "Visiting "+link_current
  puts "Found: "+get_links(link_current).to_s
  links.merge(get_links(link_current))
  File.open("links.txt", 'w') { |file| file.write(links.to_s) }
end

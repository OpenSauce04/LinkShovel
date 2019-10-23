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
puts "\e[H\e[2J"
puts "LinkShovel"
puts "‾‾‾‾‾‾‾‾‾‾"
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

kill=0
for i in 1..30
Thread.new {
for i in 0..BigDecimal::INFINITY
  begin
    link_current=links.to_a.sample
    links.merge(get_links(link_current))
  rescue
    next
  end
  if kill==1 then
  	puts "\e[H\e[2J"
  	puts "Exiting... (This may take a while)"
  	abort
  end
end
}
end
Thread.new {
links_int=links.to_a.length.to_s
for i in 0..BigDecimal::INFINITY
  begin
    puts "\e[H\e[2J"
    puts "LinkShovel"
    puts "‾‾‾‾‾‾‾‾‾‾"
    puts "Found "+links_int+" sites."
    puts
    puts "Press Enter to stop"
    links_int=links.to_a.length.to_s
    sleep 0.1
  end
end
}
gets
kill=1
puts "\e[H\e[2J"
puts "Exiting... (This may take a while)"
File.open("links.txt", 'w') { |file| file.write(links.to_s) }
abort
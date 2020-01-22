puts "Initializing..."
require 'nokogiri'
require 'open-uri'
require 'set'
require 'bigdecimal'
def get_links(url)
  Nokogiri::HTML(open(url).read).css("a").map do |link|
    if (href = link.attr("href"))
      href
    end
  end.compact
end
links = Set[]
init_links = []
puts "Reading config..."
config = File.read('config.html')
Nokogiri::HTML(config).css("a").map do |link|
  if (href = link.attr("href"))
    puts "  "+href
    init_links.append(href)
  end
end.compact
init_links.each { |url|
    links.merge(get_links(url))
}
puts "Testing connection..."
begin
  get_links("http://google.com")
rescue
  puts "Connection failed, check your connection and try again"
  exit
end
puts "  Success!"
puts "Starting Threads..."
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
end
}
puts "  Thread "+i.to_s+" ready!"
end
puts "Entering main loop..."
puts "\e[H\e[2J"
Thread.new {
links_int=links.to_a.length.to_s
for i in 0..BigDecimal::INFINITY
  begin
    puts "\033[0;0H"
    puts "LinkShovel"
    puts "‾‾‾‾‾‾‾‾‾‾"
    puts "Found "+links_int+" pages."
    puts
    puts "Press Enter to stop"
    links_int=links.to_a.length.to_s
    sleep 0.1
  end
end
}
gets
puts "\e[H\e[2J"
puts "Exiting..."
File.open("links.txt", 'w') { |file| file.write(links.to_s) }
puts "\e[H\e[2J"
puts "You can now close this window."
abort
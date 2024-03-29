puts "Initializing..."
require 'nokogiri'
require 'open-uri'
require 'set'
require 'bigdecimal'
def get_links(url)
  Nokogiri::HTML(URI.open(url).read).css("a").map do |link|
    if (href = link.attr("href"))
      href
    end
  end.compact
end
links = Set[]
init_links = []

puts "Testing connection..."
begin
  get_links("http://google.com")
rescue
  puts "Connection failed, check your connection and try again"
  exit
end
puts "  Success!"

puts "Reading config..."
config = File.read('config.html')
Nokogiri::HTML(config).css("a").map do |link|
  if (href = link.attr("href"))
    puts "  "+href
    init_links.append(href)
  end
end.compact
initscrapecount=0
init_links.each { |url|
  initscrapecount+=1
  begin
    puts "\e[H\e[2J"
    puts "Performing initial scrape (this may take a while)... "+(initscrapecount/2).to_s+"%"
    puts "Current: "+url
    links.merge(get_links(url))
  rescue
    next
  end
}
kill=0
threadreadycount=1
threadtotalcount=0
File.open("./threads.txt", "r") do |f|
  f.each_line do |line|
    threadtotalcount=line.to_i
  end
end
puts "Starting Threads..."
cycleno=0
lastSaveIncrement=0
for i in 1..threadtotalcount
Thread.new {
  puts "  Thread "+threadreadycount.to_s+" started!"
  threadreadycount+=1
  for i in 0..BigDecimal::INFINITY
    begin
      cycleno+=1
      if cycleno.div(1000)>lastSaveIncrement
        lastSaveIncrement = cycleno.div(1000)
        File.open("links.txt", 'w') { |file| file.write(links.to_s) }
      end
      link_current=links.to_a.sample
      links.merge(get_links(link_current))
    rescue
      next
    end
  end
}
end
puts "Entering main loop..."
puts "\e[H\e[2J"
Thread.new {
links_int=links.to_a.length.to_s
for i in 0..BigDecimal::INFINITY
  begin
    for i in 0..200
      begin
        puts "\033[0;0H"
        puts "LinkShovel"
        puts "‾‾‾‾‾‾‾‾‾‾"
        puts "Cycle no. "+cycleno.to_s
        puts "Next save: Cycle "+((lastSaveIncrement+1)*1000).to_s

        puts "Found "+links_int+" pages"
        
        puts
        puts "Press Enter to stop"
        links_int=links.to_a.length.to_s
        sleep 0.1
      end
      puts "\e[H\e[2J"
    end
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
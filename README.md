# LinkShovel
When given a URL (e.g. https://google.com), LinkShovel will scrape every URL linked to on that site, and will put it into links.txt. It will then randomly pick a link from links.txt and will search that URL for links, which it will then add to links.txt, and this will repeat until the program turned off

Before running you need to install the nokogiri gem with the following commands:

`sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev -y`

`gem install nokogiri`

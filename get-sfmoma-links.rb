require "rubygems"
require "nokogiri"
require "open-uri"
require "spidr"

artist_links = []
artist_links_file = File.open("sfmoma_links.txt", "w")

Spidr.site("https://www.sfmoma.org") do |spider|
  spider.every_url do |url|
    if url.to_s.include?("/artist/")
      puts "Got an artist: #{url}"
      artist_links_file.puts url
      artist_links_file.flush
    end
  end
end

artist_links_file.close
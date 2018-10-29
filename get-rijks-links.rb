require "rubygems"
require "nokogiri"
require "open-uri"
require "spidr"

artist_links = []
artist_links_file = File.open("rikjs_links.txt", "w")

Spidr.site("https://www.rijksmuseum.nl/en/rijksstudio/artists/johannes-vermeer", hosts: ["www.rijksmuseum.nl"]) do |spider|
  spider.every_url do |url|
    if url.to_s.include?("/artists/")
      puts "Got an artist: #{url}"
      artist_links_file.puts url
      artist_links_file.flush
    end
  end
end

artist_links_file.close
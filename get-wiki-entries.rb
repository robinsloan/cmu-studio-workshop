require "rubygems"
require "nokogiri"
require "open-uri"
require "uri"

filenames = Dir["*.txt"]

filenames = filenames.select do |filename|
  filename.match(/^wiki_/)
end

filenames = ["wiki_new_media_links.txt", "wiki_avant_garde_2_links.txt"]

filenames.each do |filename|
    File.open(filename).each_line do |link|
    puts "Snagging #{link}"

    begin
      doc = Nokogiri::HTML(open("https://en.wikipedia.org"+link.strip))
    rescue
      puts "Well that crapped out"
      next
    end

    grafs = doc.css("#mw-content-text p")

    text = ""

    grafs.each do |graf|
      text += graf.text
    end

    text = text.gsub(/\[\d+\]/, "")
    new_file = File.open("wiki-entries/"+link.gsub(/\W/,"_")+".txt", "w")
    new_file.puts text
    new_file.close
  end
end
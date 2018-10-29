require "rubygems"
require "nokogiri"
require "open-uri"
require "uri"

# .artist-biography

File.open("rijks_links.txt").each_line do |link|
  puts "Trying #{link}"

  begin
    doc = Nokogiri::HTML(open(link.strip))
  rescue
    puts "HEY"
    next
  end

  bio_grafs = doc.css(".text-intro div p")

  text = ""

  bio_grafs.each do |bio_graf|
    text += bio_graf.text
  end

  unless text == ""
    puts "Got a bio for #{link}"
    filename = link.split("/").last + ".txt"
    new_file = File.open("rijks_bios/" + filename, "w")
    new_file.puts text
    new_file.close
  end
end
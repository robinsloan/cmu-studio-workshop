require "rubygems"
require "nokogiri"
require "open-uri"
require "spidr"

(1..6650).each do |num|
  url = "https://www.moma.org/artists/" + num.to_s
  puts "Doing #{url}"
  begin
    doc = Nokogiri::HTML(open(url))
  rescue
    next
  end

  text = ""
  bio_grafs = doc.css(".artist__intro-text--hidden p")

  bio_grafs.each do |graf|
    if graf.text.length > 100
      text += graf.text
    end
  end

  additional_grafs = doc.css("dd.text")

  additional_grafs.each do |graf|
    if graf.text.length > 100
      text += graf.text
    end
  end

  unless text == ""
    puts "Got a bio! Saving"
    new_filename = url.gsub(/\W/, "_") + ".txt"
    new_file = File.open("nymoma_bios/" + new_filename, "w")
    new_file.puts text
    new_file.close
  end
end
require "rubygems"

filenames = Dir["wiki-entries/*.txt"]

filenames += Dir["moma_bios/*.txt"]

filenames += Dir["rijks_bios/*.txt"]

filenames += Dir["nymoma_bios/*.txt"]

filenames = filenames.select do |link|
  !link.include?("_links")
end

def clean(text)
  text = text.gsub(/\s+/, " ") # white space
  text = text.gsub(/\'\'/,"\"") # double apostrophes
  text = text.gsub("‘","\'")
  text = text.gsub("’","\'")
  text = text.gsub("“","\"")
  text = text.gsub("”","\"")
  text = text.gsub("—", "--")
  text = text.gsub("–", "-")
  text = text.gsub(/((\.|\ \.){2,})/,".") # ellipses, incl long-ass

  # tragic, but necessary (for now)
  text = text.gsub(/[ÀÁÂÄÆÃÅĀ]/,"A")
  text = text.gsub(/[ÈÉÊËĒĖĘ]/,"E")
  text = text.gsub(/[ÎÏÍĪĮÌ]/,"I")
  text = text.gsub(/[ÔÖÒÓŒØŌÕ]/,"O")
  text = text.gsub(/[ÛÜÙÚŪ]/,"U")

  text = text.gsub(/[àáâäæãåā]/,"a")
  text = text.gsub(/[èéêëēėę]/,"e")
  text = text.gsub(/[îïíīįì]/,"i")
  text = text.gsub(/[ôöòóœøōõ]/,"o")
  text = text.gsub(/[ûüùúū]/,"u")

  text = text.gsub(/[^A-Za-z0-9\:\!\?\-\,\;\'\.\(\)\#\"\ ]/, "")

  return text
end

complete_text = ""

filenames.shuffle!

filenames.each do |filename|
  puts "Doing #{filename}"
  full_text = ""

  File.open(filename).each_line do |line|
    full_text += clean(line).strip + " "
  end

  complete_text += full_text + " "
end

puts "Processing complete text"

complete_text = complete_text.gsub(/\s+/, " ")

new_file = File.open("wiki_text_monday.txt", "w")
new_file.puts complete_text
new_file.close
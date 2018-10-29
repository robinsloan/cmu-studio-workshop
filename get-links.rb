require "rubygems"
require "nokogiri"
require "open-uri"
require "uri"

$visited_links = {}

$artist_links = {}
# make the list of links

def scrape_artist_links_from(url, recursion_level)

  if (recursion_level > 1) then
    return
  end

  if $visited_links[url] then
    return
  else
    $visited_links[url] == true
  end

  unless url.match(/^\/wiki\//)
    return
  end

  puts "Scraping #{url}, recursion level #{recursion_level}"

  begin
    doc = Nokogiri::HTML(open("https://en.wikipedia.org"+url))
  rescue
    return
  end

  doc.css("a").each do |link|
    if (link[:href] && link[:href].include?("artists")) then
      scrape_artist_links_from(link[:href], recursion_level+1)
    else
      if (link[:title] && link[:href]) then
        escaped = URI.escape( link[:title].gsub(" ", "_") )
        if link[:href].include?(escaped) then
          begin
            doc = Nokogiri::HTML(open("https://en.wikipedia.org"+link[:href]))
          rescue
            break
          end
          if doc.css("#mw-content-text").to_html.include?("(born")
            unless $artist_links[link[:href]]
              puts "Got an artist!"
              puts link[:href]
              $artist_links[link[:href]] = true
              $artist_link_file.puts link[:href]
              $artist_link_file.flush
            end
          end
        end
      end
    end
  end
end

artist_mega_page_link = "/wiki/Avant-garde"

$artist_link_file = File.open("wiki_avant_garde_2_links.txt", "w")

scrape_artist_links_from(artist_mega_page_link, 0)
#scrape_artist_links_from("https://en.wikipedia.org/wiki/List_of_American_artists_before_1900", 0)
#scrape_artist_links_from("https://en.wikipedia.org/wiki/List_of_American_artists_1900_and_after", 0)

puts $artist_links
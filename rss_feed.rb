require 'rss'
require 'open-uri'
require 'httparty'
require 'nokogiri'


@default_request_headers = {
'Content-Type' => 'application/x-www-form-urlencoded',
'Accept-Language' => 'en-US,en;q=0.5',
'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0',
'Referer' => 'https://dev.workmarket.com/',
'Accept-Encoding' => 'gzip,deflate'
}
url = 'http://newyork.craigslist.org/search/aap/mnh?housing_type=1&maxAsk=3000&minAsk=800&nh=131&nh=136&nh=137&s=0&sale_date=-&format=rss'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  puts "Link: #{feed.channel.link}"
  feed.items.each do |item|
    puts "Item: #{item.link}"
    response = HTTParty.get(item.link, :headers => @default_request_headers)
    # puts response
    body = Nokogiri::HTML(response)
    
    #Response body does not conatain the generic craigslist email... wtf its in the DOM if you look at the page
    some_email = body.xpath("//a[contains(text(), '@')]").text
    puts some_email
  end
end

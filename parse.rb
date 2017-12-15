require 'mechanize'
_TOC = %w[http://rvb.ru/pushkin/tocvol3.htm]
TOC = %w[http://rvb.ru/pushkin/tocvol1.htm http://rvb.ru/pushkin/tocvol2.htm
         http://rvb.ru/pushkin/tocvol3.htm http://rvb.ru/pushkin/tocvol4.htm]

no_txt = []
no_title = []
titles = []
links = []
agent = Mechanize.new
TOC.each do |toc|
  page = agent.get(toc)
  links += page.links_with(xpath: '//a[@name]')
end
puts
links.each do |link|
  print '.'
  page = link.click
  url = link.uri.to_s
  title = link.text
  title.gsub!(/\(.*?\)/, ' ')
  title.gsub!('«', ' ')
  title.gsub!('»', ' ')
  title.gsub!('...', ' ')
  title.strip!
  titles << title
  txt = page.xpath('//h1/following-sibling::div[1]').text.strip
  if title.eql?("")
    no_title << url
  end
  if txt.eql?("")
    no_txt << url
  end

#  puts "URL: #{url}"
#  puts 'Title:'
#  puts title
#  puts 'TEXT:'
#  puts txt
end

puts
puts 'Titles:'
puts titles.sort
puts 'NO_TITLE:'
puts no_title
puts 'NO_TXT:'
puts no_txt

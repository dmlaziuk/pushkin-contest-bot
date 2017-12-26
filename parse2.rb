require 'mechanize'

TOC = %w[http://rvb.ru/pushkin/tocvol1.htm http://rvb.ru/pushkin/tocvol2.htm
         http://rvb.ru/pushkin/tocvol3.htm http://rvb.ru/pushkin/tocvol4.htm]

verses = []
links = []
agent = Mechanize.new
TOC.each do |toc|
  page = agent.get(toc)
  links += page.links_with(xpath: '//a[@name]')
end
links.each do |link|
  print '.'
  page = link.click
  title = link.text.gsub(/ \(.*?\)/, '')
  quote = title.scan(/«(.*?)...»/)
  title = quote[0][0] unless quote.empty?
  title = title[0...-1] if title[-1] == '.'
  title.gsub!(/ — \d+/, '')
  txt = page.xpath('//span[@class="line"]')
  arr = []
  txt.each do |i|
    line = i.text
    line.gsub!(' ', ' ')       # special character
    line.gsub!('‎', ' ')       # special character
    line.gsub!(/\s+/, ' ')
    line.strip!
    arr << line
  end
  verses << [title, arr]
end
puts
File.open('lyrics2.yml', 'w') { |f| f.write(YAML.dump(verses)) }

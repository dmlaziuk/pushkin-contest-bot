require 'mechanize'

URL = 'http://ilibrary.ru/author/pushkin/l.all/index.html'.freeze

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

verses = []
page = agent.get(URL)
links = page.xpath('//div[@class="list"]/p')
total = links.size
count = 1
links.each do |link|
#  print "\r#{count}/#{total}"
  title = link.text.gsub(/ \(.*?\)/, '')
  title.gsub!('', '')
  title.gsub!(/\s+/, ' ')
  quote = title.scan(/«(.*?)...»/)
  title = quote[0][0] unless quote.empty?
  puts "TITLE:#{title}"
  url = "http://ilibrary.ru#{link.xpath('./a').attribute('href')}"
  url.gsub!('index.html', 'p.1/index.html')
  page = agent.get(url)
  ttl = nil
  begin
    ttl ||= page.xpath('//div[@class="title"]/h1').text
    ttl = title if ttl.empty?
    ttl = title if ttl.include?('*')
    ttl.gsub!(' ', '')
    ttl.gsub!(/\d+$/, '')
    ttl.gsub!(/\s+/, ' ')
    puts "  TTL:#{ttl}"
    txt = page.xpath('//span[@class="vl"]')
    if txt.any?
      arr = []
      txt.each do |i|
        line = i.text
        line.gsub!(' ', ' ')
        line.gsub!("\u0097", ' ')
        line.gsub!(/\d+$/, ' ')
        line.gsub!(/ \d+.$/, '.')
        line.gsub!(/\s+/, ' ')
        line.strip!
        arr << line
      end
      verses << [ttl, arr]
    end
    next_page = page.link_with(xpath: '//a[@title="Дальше"]')
    page = next_page.click if next_page
  end while next_page
  count += 1
end

File.open('lyrics3.yml', 'w') { |f| f.write(YAML.dump(verses)) }

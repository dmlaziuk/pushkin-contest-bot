require 'benchmark'
require 'mechanize'

include Benchmark

URL = 'http://ilibrary.ru/author/pushkin/l.all/index.html'.freeze

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

verses = []
page = agent.get(URL)
links = page.xpath('//div[@class="list"]/p')
total = links.size
count = 1
time = Tms.new
total_time = Tms.new
benchmark(CAPTION, 11, FORMAT, ' Total time', 'Averge time') do |bm|
  links.each do |link|
    time = bm.report(format('%4d / %4d', count, total)) do
      title = link.text.gsub(/ \(.*?\)/, '')
      title.gsub!('', '')
      title.gsub!(/\s+/, ' ')
      quote = title.scan(/«(.*?)...»/)
      title = quote[0][0] unless quote.empty?
      url = "http://ilibrary.ru#{link.xpath('./a').attribute('href')}"
      url.gsub!('index.html', 'p.1/index.html')
      page = agent.get(url)
      title2 = nil
      begin
        title2 ||= page.xpath('//div[@class="title"]/h1').text
        title2 = title if title2.empty?
        # title2 = title if title2.include?('*')
        #title2.gsub!(' ', '')
        #title2.gsub!(/\d+$/, '')
        #title2.gsub!(/\s+/, ' ')
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
          verses << [title2, arr]
        end
        next_page = page.link_with(xpath: '//a[@title="Дальше"]')
        page = next_page.click if next_page
      end while next_page
      count += 1
    end
    total_time += time
  end
  [total_time, total_time / (count - 1)]
end

File.open('lyrics3.yml', 'w') { |f| f.write(YAML.dump(verses)) }

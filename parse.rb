require 'json'
require 'mechanize'

TOC = 'lyrics.json'.freeze

agent = Mechanize.new
data = JSON.parse(File.read(TOC))
verses = []

puts 'Parsing'
data.each do |item|
  title = item[0].gsub(/ \(.*?\)/, '')
  page = agent.get(item[1])
  txt = page.xpath('//div[@class="poem"]').text
  txt.gsub!(' ', ' ')       # special character
  txt.gsub!('‎', ' ')       # special character
  txt.gsub!(/^\d+/, ' ')    # line numbers
  txt.gsub!(/\[.*?\]/, '')  # square brackets
  txt.gsub!(/<.*?>/, ' ')   # angle brackets
  txt.gsub!(/\(.*?\)/, ' ') # parenthesis
  txt.gsub!(/ \d+ /, ' ')   # references
  arr = txt.split("\n")
  arr.map! { |line| line.gsub(/\s+/, ' ').strip } # multiple spaces
  arr.map! do |line|
    line.length == 0 ? nil : line
  end
  arr.compact!
  verses << [title, arr]
  print '.'
end
puts
File.open('lyrics.yml', 'w') { |f| f.write(YAML.dump(verses)) }

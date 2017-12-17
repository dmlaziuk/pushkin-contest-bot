require 'json'
require 'mechanize'
require_relative 'lib/pushkin'

TOC = 'lyrics.json'.freeze

agent = Mechanize.new
data = JSON.parse(File.read(TOC))
pushkin = Pushkin.new

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
  pushkin.add(title, arr)
  print '.'
end

#puts "\n#{pushkin}"
pushkin.init_hash
File.open('pushkin.yml', 'w') { |f| f.write(YAML.dump(pushkin)) }
File.open('pushkin.dump', 'wb') { |f| f.write(Marshal.dump(pushkin)) }

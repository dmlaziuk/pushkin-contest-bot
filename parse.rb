require 'json'
require 'mechanize'
require_relative 'lib/pushkin'

TOC = '1825.json'.freeze

def parse(page)
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
  puts arr
end

data = JSON.parse(File.read(TOC))

agent = Mechanize.new

data.each do |i|
  title = i[0]
  url = i[1]
  puts "#{title}\n\n"
  page = agent.get(url)
  parse(page)
  puts "\n\n"
end

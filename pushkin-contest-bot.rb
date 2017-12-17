require 'yaml'
require_relative 'lib/pushkin'

pushkin = Pushkin.new
puts 'loading lyrics.yml ...'
verses = YAML.load(File.read('lyrics.yml'))
puts 'adding verses ...'
verses.each do |verse|
  pushkin.add(verse[0], verse[1])
end
puts 'initializing hash ...'
pushkin.init_hash
puts 'runing level1 ...'
puts pushkin.run_level1('Он уважать себя заставил')

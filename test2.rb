require 'yaml'

arr1 = []
arr2 = []
verses = YAML.load(File.read('lyrics.yml'))
verses.each do |verse|
  arr1 << verse[0]
end
verses = YAML.load(File.read('lyrics2.yml'))
verses.each do |verse|
  arr2 << verse[0]
end

puts arr1 - arr2

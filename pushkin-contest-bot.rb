require 'yaml'
require 'json'
require 'net/http'
require 'rack'
require_relative 'lib/pushkin'

TOKEN = '7cb21edad8e21d1abf2147b12f89f276'.freeze
MYURI = URI('http://pushkin.rubyroidlabs.com/quiz')

class PushkinContestBot
  def initialize
    @pushkin = Pushkin.new
    verses = YAML.load(File.read('lyrics2.yml'))
    verses.each do |verse|
      @pushkin.add(verse[0], verse[1])
    end
    @pushkin.init_hash
  end

  def call(env)
    request = JSON(env['rack.input'].read)
    question = request['question']
    id = request['id']
    level = request['level']
    puts "Question:#{question}"
    case level
    when 1
      words = question.scan(/[\p{Word}\-]+/).join(' ')
      puts "   Words:#{words}"
      answer = @pushkin.run_level1(words)
    when 2
      words = question.scan(/[\p{Word}\-]+/).join(' ')
      puts "   Words:#{words}"
      answer = @pushkin.run_level2(words)
    when 3
      arr = question.split("\n")
      arr.map! { |line| line.scan(/[\p{Word}\-]+/).join(' ') }
      arr.each { |line| puts "   Words:#{line}"}
      answer = @pushkin.run_level3(arr)
    end
    puts "  Answer:#{answer}"
    parameters = {answer: answer, token: TOKEN, task_id: id}
    Net::HTTP.post_form(MYURI, parameters)
    [200, {}, []]
  end
end

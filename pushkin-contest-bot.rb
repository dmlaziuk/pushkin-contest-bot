require 'yaml'
require 'json'
require 'net/http'
require 'rack'
require_relative 'lib/pushkin'

TOKEN = '7cb21edad8e21d1abf2147b12f89f276'.freeze
MY_URI = URI('http://pushkin.rubyroidlabs.com/quiz')

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
    return [200, {}, []] if env['REQUEST_METHOD'] == 'GET'
    request = JSON(env['rack.input'].read)
    question = request['question']
    id = request['id']
    level = request['level']
    puts "Question:#{question}"
    answer = case level
    when 1
      @pushkin.run_level1(question)
    when 2
      @pushkin.run_level2(question)
    when 3
      @pushkin.run_level3(question)
    when 4
      @pushkin.run_level4(question)
    when 5
      @pushkin.run_level5(question)
    when 6
      @pushkin.run_level6(question)
    when 7
      @pushkin.run_level7(question)
    when 8
      @pushkin.run_level8(question)
    else
      'нет'
    end
    puts "  Answer:#{answer}"
    parameters = {answer: answer, token: TOKEN, task_id: id}
    Net::HTTP.post_form(MY_URI, parameters)
    [200, {}, []]
  end
end

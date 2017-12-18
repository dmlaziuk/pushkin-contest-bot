require 'yaml'
require 'json'
require 'net/http'
require 'rack'
require_relative 'lib/pushkin'

class PushkinContestBot
  def initialize
    @token = '7cb21edad8e21d1abf2147b12f89f276'
    @uri = URI('http://pushkin.rubyroidlabs.com/quiz')
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
    arr = question.scan(/[\p{Word}\-]+/)
    q = arr.join(' ')
    puts "Words:#{q}"
    answer = @pushkin.run_level1(q)
    puts "Answer:#{answer}"
    parameters = {answer: answer, token: @token, task_id: id}
    Net::HTTP.post_form(@uri, parameters)
    resp = Rack::Response.new
    resp.status = 200
    resp.finish
  end
end

require 'benchmark'
require 'json'
require 'yaml'
require 'logger'
require 'net/http'
require_relative 'lib/pushkin'

include Benchmark

TOKEN = '7cb21edad8e21d1abf2147b12f89f276'.freeze
MY_URI = URI('http://pushkin.rubyroidlabs.com/quiz')
LOGFILE = 'pushkin.log'
LYRICS = 'lyrics3.yml'
LEVELS = 8

class PushkinContestBot
  def initialize
    @count = [0] * (LEVELS + 1)
    @time = [Tms.new] * (LEVELS + 1)
    # @logger = Logger.new(LOGFILE, level: :info)
    # @logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
    @pushkin = Pushkin.new
    verses = []
    # @logger.info "   Lyrics:#{LYRICS}"
    time = measure { verses = YAML.load(File.read(LYRICS)) }
    # @logger.info "Load YAML:#{time}".chomp
    time = measure { verses.each { |verse| @pushkin.add(verse[0], verse[1]) }}
    # @logger.info "Add2array:#{time}".chomp
    time = measure { @pushkin.init_hash }
    # @logger.info "Init hash:#{time}".chomp
  end

  def call(env)
    return results if env['REQUEST_METHOD'] == 'GET'
    answer = 'нет'
    request = JSON(env['rack.input'].read)
    question = request['question']
    id = request['id']
    level = request['level']

    time = measure do 
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
      end
    end

    @time[level] += time
    @count[level] += 1
    # @logger.info " Level #{level}:#{@count[level]}"
    # @logger.info "Question:#{question}"
    # @logger.info "  Answer:#{answer}"
    # @logger.info "    Time:#{@time[level]}"

    parameters = { answer: answer, token: TOKEN, task_id: id }
    Net::HTTP.post_form(MY_URI, parameters)
    [200, {}, []]
  end

  def results
    txt = (1..LEVELS).map { |i| "Level #{i}:#{@count[i]} => #{@time[i]}" }
    txt << "  Total:#{@count.sum} => #{@time.reduce(:+)}"
    [200, {'Content-Type' => 'text/plain'}, txt]
  end
end

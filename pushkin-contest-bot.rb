require 'benchmark'
require 'yaml'
require 'net/http'
require_relative 'lib/pushkin'

include Benchmark

TOKEN = '7cb21edad8e21d1abf2147b12f89f276'.freeze
MY_URI = URI('http://pushkin.rubyroidlabs.com/quiz')

class PushkinContestBot
  def initialize
    @pushkin = Pushkin.new
    @count = [0]*9
    @time = Tms.new
    @total_time = [Tms.new]*9
    verses = []
    benchmark(CAPTION, 10, FORMAT) do |bm|
      bm.report('Load YAML:') { verses = YAML.load(File.read('lyrics3.yml')) }
      bm.report('Add2array:') do
        verses.each do |verse|
          @pushkin.add(verse[0], verse[1])
        end
      end
      bm.report('Init hash:') { @pushkin.init_hash }
    end
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
      @count[1] += 1
      @time = measure("Level 1/#{@count[1]}") { @pushkin.run_level1(question) }
      @total_time[1] += @time
    when 2
      @count[2] += 1
      first ||= puts "Level 1: total=#{@total_time[1]} average=#{@total_time[1]/@count[1]}"
      @time = measure("Level 2/#{@count[2]}") { @pushkin.run_level2(question) }
      @total_time[2] += @time
    when 3
      @count[3] += 1
      second ||= puts "Level 2: total=#{@total_time[2]} average=#{@total_time[2]/@count[2]}"
      @time = measure("Level 3/#{@count[3]}") { @pushkin.run_level3(question) }
      @total_time[3] += @time
    when 4
      @count[4] += 1
      third ||= puts "Level 3: total=#{@total_time[3]} average=#{@total_time[3]/@count[3]}"
      @time = measure("Level 4/#{@count[4]}") { @pushkin.run_level4(question) }
      @total_time[4] += @time
    when 5
      @count[5] += 1
      fourth ||= puts "Level 4: total=#{@total_time[4]} average=#{@total_time[4]/@count[4]}"
      @time = measure("Level 5/#{@count[5]}") { @pushkin.run_level5(question) }
      @total_time[5] += @time
    when 6
      @count[6] += 1
      fifth ||= puts "Level 5: total=#{@total_time[5]} average=#{@total_time[5]/@count[5]}"
      @time = measure("Level 6/#{@count[6]}") { @pushkin.run_level6(question) }
      @total_time[6] += @time
    when 7
      @count[7] += 1
      sixth ||= puts "Level 6: total=#{@total_time[6]} average=#{@total_time[6]/@count[6]}"
      @time = measure("Level 7/#{@count[7]}") { @pushkin.run_level7(question) }
      @total_time[7] += @time
    when 8
      @count[8] += 1
      seventh ||= puts "Level 7: total=#{@total_time[7]} average=#{@total_time[7]/@count[7]}"
      @time = measure("Level 8/#{@count[8]}") { @pushkin.run_level8(question) }
      @total_time[8] += @time
      puts "Level 8: total=#{@total_time[8]} average=#{@total_time[8]/@count[8]}" if count[8] > 98
    else
      'нет'
    end
    puts "  Answer:#{answer}"
    parameters = {answer: answer, token: TOKEN, task_id: id}
    Net::HTTP.post_form(MY_URI, parameters)
    [200, {}, []]
  end
end

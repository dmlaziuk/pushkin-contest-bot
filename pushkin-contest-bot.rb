require 'benchmark'
require 'json'
require 'yaml'
require 'logger'
require 'net/http'
require_relative 'lib/pushkin'

include Benchmark

TOKEN = '7cb21edad8e21d1abf2147b12f89f276'.freeze
MY_URI = URI('http://pushkin.rubyroidlabs.com/quiz')

class PushkinContestBot
  def initialize
    @pushkin = Pushkin.new
    @count = [0]*9
    @result = []*8
    @time = Tms.new
    @total_time = [Tms.new]*9
    @logger = Logger.new('pushkin.log', level: :info)
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
    answer = 'нет'
    request = JSON(env['rack.input'].read)
    question = request['question']
    id = request['id']
    level = request['level']
    @logger.info "Question:#{question}"
    case level
    when 1
      @time = measure { answer = @pushkin.run_level1(question) }
      @count[1] += 1
      @logger.info "Lvl 1/#{@count[1]}:#{@time}"
      @total_time[1] += @time
    when 2
      unless @result[1]
        @result[1] = "   Level 1:\n     Total:#{@total_time[1]}   Average:#{@total_time[1]/@count[1]}     Count:#{@count[1]}"
        @logger.info @result[1]
      end
      @time = measure { answer = @pushkin.run_level2(question) }
      @count[2] += 1
      @logger.info "Lvl 2/#{@count[2]}:#{@time}"
      @total_time[2] += @time
    when 3
      unless @result[2]
        @result[2] = "   Level 2:\n     Total:#{@total_time[2]}   Average:#{@total_time[2]/@count[2]}     Count:#{@count[2]}"
        @logger.info @result[2]
      end
      @time = measure { answer = @pushkin.run_level3(question) }
      @count[3] += 1
      @logger.info "Lvl 3/#{@count[3]}:#{@time}"
      @total_time[3] += @time
    when 4
      unless @result[3]
        @result[3] = "   Level 3:\n     Total:#{@total_time[3]}   Average:#{@total_time[3]/@count[3]}     Count:#{@count[3]}"
        @logger.info @result[3]
      end
      @time = measure { answer = @pushkin.run_level4(question) }
      @count[4] += 1
      @logger.info "Lvl 4/#{@count[4]}:#{@time}"
      @total_time[4] += @time
    when 5
      unless @result[4]
        @result[4] = "   Level 4:\n     Total:#{@total_time[4]}   Average:#{@total_time[4]/@count[4]}     Count:#{@count[4]}"
        @logger.info @result[4]
      end
      @time = measure { answer = @pushkin.run_level5(question) }
      @count[5] += 1
      @logger.info "Lvl 5/#{@count[5]}:#{@time}"
      @total_time[5] += @time
    when 6
      unless @result[5]
        @result[5] = "   Level 5:\n     Total:#{@total_time[5]}   Average:#{@total_time[5]/@count[5]}     Count:#{@count[5]}"
        @logger.info @result[5]
      end
      @time = measure { answer = @pushkin.run_level6(question) }
      @count[6] += 1
      @logger.info "Lvl 6/#{@count[6]}:#{@time}"
      @total_time[6] += @time
    when 7
      unless @result[6]
        @result[6] = "   Level 6:\n     Total:#{@total_time[6]}   Average:#{@total_time[6]/@count[6]}     Count:#{@count[6]}"
        @logger.info @result[6]
      end
      @time = measure { answer = @pushkin.run_level7(question) }
      @count[7] += 1
      @logger.info "Lvl 7/#{@count[7]}:#{@time}"
      @total_time[7] += @time
    when 8
      unless @result[7]
        @result[7] = "   Level 7:\n     Total:#{@total_time[7]}   Average:#{@total_time[7]/@count[7]}     Count:#{@count[7]}"
        @logger.info @result[7]
      end
      @time = measure { answer = @pushkin.run_level8(question) }
      @count[8] += 1
      @total_time[8] += @time
      @logger.info "Lvl 8/#{@count[8]}:#{@time}"
      @logger.info "   Level 8:\n     Total:#{@total_time[8]}   Average:#{@total_time[8]/@count[8]}     Count:#{@count[8]}" if count[8] > 99
    end
    @logger.info "  Answer:#{answer}"
    parameters = {answer: answer, token: TOKEN, task_id: id}
    Net::HTTP.post_form(MY_URI, parameters)
    [200, {}, []]
  end
end

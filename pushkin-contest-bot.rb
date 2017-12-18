require 'yaml'
require 'net/http'
require 'rack'
require_relative 'lib/pushkin'

class PushkinContestBot
  def initialize
    @token = '7cb21edad8e21d1abf2147b12f89f276'
    @pushkin = Pushkin.new
    verses = YAML.load(File.read('lyrics.yml'))
    verses.each do |verse|
      @pushkin.add(verse[0], verse[1])
    end
    @pushkin.init_hash
  end

  def self.call(env)
    req = Rack::Request.new(env)
    puts 'REQ'
    p req
    puts 'PARAMS'
    p req.params
    puts 'GET'
    p req.GET
    Rack::Response.new("OK", 200)
#    answer = pushkin.run_level1('Он уважать себя заставил')
#    uri = URI("http://pushkin.rubyroidlabs.com/quiz")
#    parameters = {
#      answer: "#{answer}",
#      token: "#{token}",
#      task_id: "#{task_id}"
#    }
#    Net::HTTP.post_form(uri, parameters)
  end
end

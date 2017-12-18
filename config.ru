# This file is used by Rack-based servers to start the application.

#require_relative 'config/environment'

#run Rails.application

require 'rack'
require_relative 'pushkin-contest-bot'

run PushkinContestBot.new

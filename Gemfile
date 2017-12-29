source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mechanize'
gem 'puma'
gem 'rack'

group :deployment do
  gem 'capistrano', '~> 3.10'
  gem 'capistrano-bundler'
#  gem 'capistrano-rails'
  gem 'capistrano-rvm'
#  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma'
#  gem 'capistrano-db-tasks', require: false
end

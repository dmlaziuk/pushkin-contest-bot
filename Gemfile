source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Use Puma as the app server
gem 'rack'
gem 'puma', '~> 3.7'
gem 'mechanize'

# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.3'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'dry-auto_inject'
gem 'dry-container'
gem 'faraday'
gem 'newrelic_rpm'
gem 'rake'

gem 'resque'
gem 'resque-heroku-signals'
gem 'resque-web', require: 'resque_web'

# WEB stack
gem 'grape'

# DB stack
gem 'pg'
gem 'sequel'

group :test do
  gem 'rspec'
end

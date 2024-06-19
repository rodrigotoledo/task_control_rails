# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem 'jbuilder'

# Use Redis adapter to run Action Cable in production

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]

group :development, :test do
  # Tool for debugging
  gem 'byebug', '~> 11.1'
  # Loads environment variables from a .env file
  gem 'dotenv-rails'
  # Facilitates the creation of test object mocks
  gem 'factory_bot_rails'
  # Generates fake data for tests
  gem 'faker', '~> 3.2'
  # Automatically runs tests
  gem 'guard-rspec', '~> 4.7'
  # RSpec testing framework
  gem 'rspec-rails'
  # Adds support for tests with shoulda-matchers
  gem 'shoulda-matchers', require: false
  # Analyzes test coverage
  gem 'simplecov'
end

group :development do
  # Annotates models with database schema information
  gem 'annotate'
  # Security tool for Rails
  gem 'brakeman'
  # Helps detect N+1 queries in ActiveRecord
  gem 'bullet'
end

# Image processing
gem 'image_processing', '~> 1.2'
# CORS configuration for Rack
gem 'rack-cors', '~> 2.0'
# In-memory key-value database
gem 'redis', '>= 4.0.1'
# Static code analysis tool for Ruby
gem 'rubocop', require: false
# RuboCop extension for Rails
gem 'rubocop-rails', require: false
# Tailwind CSS framework for Rails
gem 'tailwindcss-rails'
# Ruby language server
gem 'solargraph'

gem "stimulus_reflex", "~> 3.5"

gem "redis-session-store", "~> 0.11.5"

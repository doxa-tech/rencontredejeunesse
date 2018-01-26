source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'

gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# HTML select list for countries
gem 'country_select'

# Common translations
gem 'rails-i18n'

gem 'database_cleaner'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'rails-controller-testing'
  gem 'cucumber-rails', :require => false
  gem 'factory_bot_rails'
  gem 'capybara-webkit'
  gem 'email_spec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'capistrano', '3.6.1'
  gem 'capistrano-maintenance', require: false
  gem 'capistrano-server', git: 'https://github.com/JS-Tech/capistrano-server'
  # rails specific capistrano funcitons
  gem 'capistrano-rails'
  # integrate bundler with capistrano
  gem 'capistrano-bundler'
  # if you are using RVM
  gem 'capistrano-rvm'
end

# authentication & authorization
gem 'adeia'

gem 'snaptable'

gem 'bcrypt'

# inline css in mailer
gem 'nokogiri'
gem 'premailer-rails'

# error tracking with sentry
gem 'sentry-raven'

# File upload
gem 'carrierwave', '~> 1.0'
gem 'mini_magick' # brew install graphicsmagick
gem 'carrierwave-imageoptimizer' # brew install optipng jpegoptim
gem 'fog-google'
gem 'google-api-client', '~> 0.8.6'
gem 'mime-types'

# Pagination
gem 'will_paginate', '~> 3.1.0'

# Code coverage
gem "codeclimate-test-reporter", group: :test, require: nil
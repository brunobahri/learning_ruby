source "https://rubygems.org"

ruby "3.1.2"

gem "rails"
gem "sqlite3", "~> 1.4.2"
gem "puma"
gem "importmap-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[mswin mswin64 mingw x64_mingw jruby]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri mswin mswin64 mingw x64_mingw]
  gem 'dotenv-rails'
  gem "rspec-rails", "~> 5.0.0"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'database_cleaner-active_record'
end

gem "devise"
gem 'devise-jwt'
gem 'rack-attack'

source 'https://rubygems.org'
ruby '2.1.7'

gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '>= 3.2'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'sidekiq'
gem 'puma'
gem 'foreman'
gem 'sentry-raven'
gem 'carrierwave'
gem 'mini_magick'
gem 'carrierwave-aws'
gem 'stripe'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'rspec-sidekiq'
  gem 'vcr'
  gem 'webmock'
  gem 'stripe-ruby-mock', '~> 2.1.1', :require => 'stripe_mock'
end

group :production, :staging do
  gem 'rails_12factor'
end


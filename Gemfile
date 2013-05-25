source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'jquery-rails'

gem 'sass-rails',   '~> 3.2'
gem 'bootstrap-sass', '~> 2.3'

gem 'thin'

gem 'geocoder'

gem 'devise'

gem 'font-awesome-rails'
gem 'font-awesome-sass-rails'

# Message board needs
gem 'forem', :git => 'git://github.com/radar/forem.git'
gem 'kaminari', '~> 0.13.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.3'
  ## Need older ruby racer for sprockets-dotjs as newer one will not build
  gem 'therubyracer', '0.10.2'
  gem 'sprockets-dotjs'
end

group :production, :development do
  gem 'pg', '0.12.2'
end

group :production do
  gem 'google-analytics-rails'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'konacha'
  gem 'guard-konacha'
end

group :test do
  gem 'capybara', '~> 1.1.2'
  gem 'sqlite3', '~> 1.3'
  gem 'factory_girl_rails', '~> 1.4.0'
  gem 'json'
end


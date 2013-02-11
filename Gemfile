source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'jquery-rails'

gem 'sass-rails',   '~> 3.2.4'
gem 'bootstrap-sass', '~> 2.2.2.0'

gem 'thin'

gem "gmaps4rails", "~> 1.5.6"

gem "geocoder"

gem "devise"

gem "font-awesome-rails"
gem "font-awesome-sass-rails"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.3'
end

group :production, :development do
  gem 'pg', '0.12.2'
end

group :development, :test do
  gem 'rspec-rails', '2.9.0'

  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1'

  gem 'konacha'
  gem 'guard-konacha'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'sqlite3', '1.3.6'
  gem 'factory_girl_rails', '~> 1.4.0'
end


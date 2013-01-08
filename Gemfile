source 'https://rubygems.org'

gem 'rails', '3.2.9'

gem 'jquery-rails'

# downgrade rack to whack security warning
gem 'rack', '1.4.1'

#gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.3'
end

group :production, :development do
  gem 'pg', '0.12.2'
end

group :development, :test do
  gem 'rspec-rails', '2.9.0'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'sqlite3', '1.3.6'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

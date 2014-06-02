source 'https://rubygems.org'

gem 'rails', '3.2.18'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', group: [:test, :development]


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'chosen-rails'
end

gem 'jquery-rails', '~> 2.1'

gem 'dotenv-rails', '~> 0.11.1', groups: [:development, :test]
# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

gem 'possessive'
# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', '~> 2.15'

# To use debugger
# gem 'debugger'
group :production do
  gem 'pg'
  gem 'unicorn'
end

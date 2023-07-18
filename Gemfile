source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

gem 'rails', '~> 6.1.7'
gem 'mysql2', '~> 0.5'
gem 'puma', '~> 5.6'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.4'
gem 'dotenv-rails', '~> 2.8'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Auditing
gem 'paper_trail', '~> 13.0'
gem 'paper_trail-association_tracking', '~> 2.2'

# Stopping the script kiddies
gem 'recaptcha', '~> 5.9'

# Encrypt sensitive model attributes
gem 'attr_encrypted', '~> 3.1'

# Remove whitespace from model attributes
gem 'strip_attributes', '~> 1.13'

# HTTP security headers
gem 'secure_headers', '~> 6.5'

# Administrator interface
gem 'rails_admin', '~> 3.0'
gem 'rails_admin_history_rollback', '~> 1.0'

# Static page serving
gem 'high_voltage', '~> 3.1'

# Raven OmniAuth login flow
gem 'omniauth-ucam-raven', '~> 2.0'

# Camdram API wrapper
gem 'camdram', git: 'https://github.com/CHTJonas/camdram-ruby.git', require: 'camdram/client'

# Date/time handling
gem 'chronic', '~> 0.10.2'
gem 'chronic_duration', '~> 0.10.6'
gem 'datey', '~> 1.1'

# Nicer console
gem 'pry-rails', '~> 0.3.9'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Annotate models
  gem 'annotate'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

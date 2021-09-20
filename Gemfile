source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 6.1.4'
gem 'mysql2', '~> 0.5'
gem 'puma', '~> 5.5'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.4'
gem 'turbolinks', '~> 5'
gem 'dotenv-rails', '~> 2.7'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Auditing
gem 'paper_trail', '~> 11.1'
gem 'paper_trail-association_tracking', '~> 2.1'

# Encrypt sensitive model attributes
gem 'attr_encrypted', '~> 3.1'

# Remove whitespace from model attributes
gem 'strip_attributes', '~> 1.11'

# HTTP security headers
gem 'secure_headers', '~> 6.3'

# Administrator interface
gem 'rails_admin', '~> 2.2'
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

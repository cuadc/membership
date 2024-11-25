source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.5"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem "stimulus-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Auditing
gem "paper_trail", "~> 15.0"
gem "paper_trail-association_tracking", "~> 2.2"

# Stopping the script kiddies
gem "recaptcha", "~> 5.17"

# Static environmental configuration
gem "dotenv-rails", "~> 3.1"

# Encrypt sensitive model attributes
gem "attr_encrypted", "~> 4.0"

# Remove whitespace from model attributes
gem "strip_attributes", "~> 1.13"

# HTTP security headers
gem "secure_headers", "~> 6.5"

# Administrator interface
gem "rails_admin", "~> 3.0"
gem "rails_admin_history_rollback", "~> 1.0"

# Static page serving
gem "high_voltage", "~> 4.0"

# Raven OmniAuth login flow
gem 'omniauth-rails_csrf_protection', '~> 1.0', '>= 1.0.1'
gem "omniauth-ucam-raven", github: "CHTJonas/omniauth-ucam-raven"

# Camdram API wrapper
gem "camdram", github: "CHTJonas/camdram-ruby", require: "camdram/client"

# Sympa mailing list API wrapper
gem 'savon', '~> 2.14'

# Date/time handling
gem "chronic", "~> 0.10.2"
gem "chronic_duration", "~> 0.10.6"
gem "datey", "~> 1.1"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Annotate model files
  gem "annotate"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

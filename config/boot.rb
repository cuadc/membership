dotenv_file_path = File.expand_path('../.env', __dir__)
if File.exist? dotenv_file_path
  require 'dotenv'
  Dotenv.load(dotenv_file_path)
end

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.

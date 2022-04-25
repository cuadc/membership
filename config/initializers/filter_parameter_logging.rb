# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password, :authenticity_token,
  'WLS-Response', 'g-recaptcha-response'
]

SecureHeaders::Configuration.default do |config|
  config.cookies = {
    httponly: true,
    samesite: {
      lax: true
    }
  }
  config.cookies.merge!({ secure: true }) if Rails.env.production?
  config.hsts = "max-age=#{1.year.to_i}" if Rails.env.production?
  unless Rails.env.development? && Rails.application.config.action_mailer.show_previews
    config.x_frame_options = "DENY"
  end
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = SecureHeaders::OPT_OUT
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = "strict-origin-when-cross-origin"
  config.csp = SecureHeaders::OPT_OUT
end

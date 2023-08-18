# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self
    policy.img_src     :self, :data
    policy.object_src  :none
    policy.child_src   'https://www.recaptcha.net'
    policy.script_src  :self, 'https://www.recaptcha.net', 'https://www.gstatic.com'
    policy.style_src   :self, :https, :unsafe_inline
    #policy.report_uri "https://www.xjupiter.net/cgi-bin/beacon"
  end

  # Generate session nonces for permitted importmap and inline scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src)

  # Report violations without enforcing the policy.
  # config.content_security_policy_report_only = true
end

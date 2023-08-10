Rails.application.config.middleware.use OmniAuth::Builder do
  keys_dir = Rails.root.join("vendor", "ucam-raven-public-keys")
  opts = { desc: "CUADC Membership System", msg: "you need to verify you are authorised to use this system" }
  provider "ucam-raven", keys_dir, opts
end

OmniAuth.config.logger = Rails.logger

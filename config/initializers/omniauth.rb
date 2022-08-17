Rails.application.config.middleware.use OmniAuth::Builder do
  key_path = Rails.root.join("config", "raven-pubkey")
  key_data = [[2, key_path]]
  opts = { desc: "CUADC Membership System", msg: "you need to verify you are authorised to use this system" }
  provider :ucamraven, key_data, opts
end

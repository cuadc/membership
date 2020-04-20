key_path = Rails.root.join("config", "raven-pubkey")
opts = { desc: "CUADC Membership System", msg: "you need to verify you are authorised to use this system", iact: "yes" }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ucamraven, 2, key_path, opts
end

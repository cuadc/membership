PaperTrail.config.track_associations = true

Rails.application.configure do
  console do
    PaperTrail.request.whodunnit = 'System Console'
  end
end

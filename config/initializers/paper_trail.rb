PaperTrail.config.track_associations = true
PaperTrail.serializer = PaperTrail::Serializers::JSON

Rails.application.configure do
  console do
    PaperTrail.request.whodunnit = 'System Console'
  end
end

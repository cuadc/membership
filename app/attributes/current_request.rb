class CurrentRequest < ActiveSupport::CurrentAttributes
  attribute :signup

  def is_signup?
    !!self.signup
  end
end

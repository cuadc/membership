# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default(
    from: 'noreply@membership.cuadc.org',
    'Auto-Submitted' => 'auto-generated'
  )

  after_action do
    self.message.instance_variable_set("@membership_mailer_class", self.class.to_s)
    self.message.instance_variable_set("@membership_mailer_method", self.action_name.to_s)
  end

  def overridable_to(addr)
    val = params.try(:fetch, :to, addr) || addr
    val.try(:uniq) || val
  end
end

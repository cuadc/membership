# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@membership.cuadc.org'
  layout 'mailer'

  def overridable_to(addr)
    params.try(:fetch, :to, addr) || addr
  end
end

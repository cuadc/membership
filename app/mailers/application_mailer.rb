# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@membership.cuadc.org'
  layout 'mailer'

  def overridable_to(addr)
    val = params.try(:fetch, :to, addr) || addr
    val.try(:uniq) || val
  end
end

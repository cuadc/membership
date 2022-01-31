# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@membership.cuadc.org'
  layout 'mailer'
end

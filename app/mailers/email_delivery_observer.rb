# frozen_string_literal: true

class EmailDeliveryObserver
  def self.delivered_email(message)
    message.recipients.uniq.each do |addr|
      SentMail.create(
        mailer_class: message.instance_variable_get("@membership_mailer_class"),
        mailer_method: message.instance_variable_get("@membership_mailer_method"),
        address: addr,
        submitted: message.date
      )
    end
  end
end

# frozen_string_literal: true

class EmailDeliveryObserver
  def self.delivered_email(message)
    message.recipients.uniq.each do |addr|
      SentMail.create(
        mailer_class: message.instance_variable_get("@mailer_class").to_s,
        mailer_action: message.instance_variable_get("@action").to_s,
        address: addr,
        submitted: message.date
      )
    end
  end
end

class EmailDeliveryObserver
  def self.delivered_email(message)
    info = message.instance_variable_get(:@_membership_mail_info)
    SentMail.create(
      mailer_class: info[:mailer_class],
      mailer_action: info[:mailer_action],
      submitted: DateTime.now,
      to: message.to.to_s,
      cc: message.cc.to_s,
      bcc: message.bcc.to_s,
    )
  end
end

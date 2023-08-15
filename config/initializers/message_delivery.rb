module ActionMailer
  class MessageDelivery < Delegator
    def deliver_once_within(timerange)
      message.to = message.to.reject { |recipient| sent_to?(recipient, timerange)}
      deliver_now
    end

    private

    def sent_to?(recipient, timerange)
      SentMail.where(
        mailer_class: @mailer_class.to_s,
        mailer_action: @action.to_s,
        submitted: DateTime.now - timerange..DateTime.now,
        address: recipient).any?
    end
  end
end

class ApplicationMailer < ActionMailer::Base
  after_action :log_mail
  layout 'mailer'
  default(
    from: 'noreply@membership.cuadc.org',
    'Auto-Submitted' => 'auto-generated'
  )

  def overridable_to(addr)
    val = params.try(:fetch, :to, addr) || addr
    val.try(:uniq) || val
  end

  private

  def log_mail
    message.instance_variable_set(:@_membership_mail_info, {
      mailer_class: self.class.name,
      mailer_action: self.action_name,
      generated: DateTime.now,
    })
  end
end

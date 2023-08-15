class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default(
    from: 'noreply@membership.cuadc.org',
    'Auto-Submitted' => 'auto-generated'
  )

  def overridable_to(addr)
    val = params.try(:fetch, :to, addr) || addr
    val.try(:uniq) || val
  end
end

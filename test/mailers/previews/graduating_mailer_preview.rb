class GraduatingMailerPreview < ActionMailer::Preview
  def check_email
    mem = Member.graduating.first
    GraduatingMailer.with(member: mem).check_email
  end
end

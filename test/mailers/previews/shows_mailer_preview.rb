class ShowsMailerPreview < ActionMailer::Preview
  def overview_email
    ShowsMailer.overview_email
  end

  def individual_email
    ShowsMailer.with(show_id: 7511).individual_email
  end
end

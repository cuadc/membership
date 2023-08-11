# frozen_string_literal: true

class ShowsMailer < ApplicationMailer
  def overview_email
    @shows = Membership::Camdram.client.get_society(1).shows
    to_addr = overridable_to('members@cuadc.org')
    mail(to: to_addr, subject: 'CUADC Show Membership Report')
  end

  def individual_email
    show_id = params[:show_id]
    to_addr = ShowContactDetails.where(camdram_id: show_id).pluck(:email).uniq
    return if to_addr.empty?
    @show = Membership::Camdram.client.get_show(show_id)
    tuples = @show.roles.map(&:person).uniq(&:id).map { |p| [p, Member.find_by(camdram_id: p.id)] }
    @non_member_tuples = tuples.select { |p| p[1].nil? || (p[1].present? && p[1].mtype_id != 1) }
    mail(to: to_addr, bcc: 'chtj2@srcf.net', subject: 'CUADC Show Membership Report')
  end
end

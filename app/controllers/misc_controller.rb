class MiscController < ApplicationController
  skip_before_action :check_user!, only: [:cudar_optout, :cudar_resign]
  before_action :check_opt_out_expiry!, only: [:cudar_optout, :cudar_resign]

  def info
    render html: Rails::Info.to_html.html_safe
  end

  def cudar_optout
    @member = Member.find_by!(uuid: params[:uuid])
  end

  def cudar_resign
    @member = Member.find_by(uuid: params[:uuid])
    PaperTrail.request.whodunnit = @member.name
    @member.destroy
  end

  private

  def check_opt_out_expiry!
    if Date.today >= Date.parse('2024-09-07')
      render inline: "Sorry, but you must have opted out before 7th October.", layout: true
    end
  end
end

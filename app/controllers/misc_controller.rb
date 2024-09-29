class MiscController < ApplicationController
  skip_before_action :check_user!, only: [:cudar_optout, :cudar_resign]

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
end

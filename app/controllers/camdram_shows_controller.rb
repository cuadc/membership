class CamdramShowsController < ApplicationController
  def index; end

  def check
    slug = params[:slug]
    if slug.nil? || slug.blank?
      render plain: 'Invalid show slug!' and return
    end
    type_ord = Type.find_by(name: "Ordinary")
    @valid_tuples = []
    @invalid_tuples = []
    show = client.get_show(slug)
    show.roles.each do |role|
      person = role.person
      member = Member.where(camdram_id: person.id).first
      if member.nil?
        @invalid_tuples.push([person, nil])
      else
        if member.type == type_ord && !member.expired?
          @valid_tuples.push([person, member])
        else
          @invalid_tuples.push([person, member])
        end
      end
    end
  end

  private

  def client
    Camdram::Client.new do |config|
      config.read_only
      config.user_agent = "CUADC Membership System v2"
      config.base_url = "https://www.camdram.net"
    end
  end
end

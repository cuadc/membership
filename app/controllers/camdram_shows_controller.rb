class CamdramShowsController < ApplicationController
  def index
    @shows = Membership::Camdram.client.get_society(1).shows
  end

  def check
    slug = params[:slug]
    if slug.nil? || slug.blank?
      render plain: 'Invalid show slug!' and return
    end
    @valid_tuples = []
    @invalid_tuples = []
    @show = Membership::Camdram.client.get_show(slug)
    @show.roles.each do |role|
      person = role.person
      member = Member.find_by(camdram_id: person.id)
      if member.nil?
        @invalid_tuples.push([person, nil])
      else
        if member.mtype_id == 1
          @valid_tuples.push([person, member])
        else
          @invalid_tuples.push([person, member])
        end
      end
    end
    @valid_tuples = @valid_tuples.uniq { |tuple| tuple.first.id }
    @invalid_tuples = @invalid_tuples.uniq { |tuple| tuple.first.id }
  end
end

module CamdramShowHelper
  def ordinary_member_row(tuple)
    member = tuple[1]
    link_to member.name, member
  end

  def non_ordinary_member_row(tuple)
    person = tuple[0]
    member = tuple[1]
    if member
      ordinary_member_row(tuple)
    else
      person.name
    end
  end
end

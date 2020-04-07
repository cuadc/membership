module MemberHelper
  def member_name(member)
    "#{member.last_name}, #{member.other_names}"
  end

  def member_expiry(member)
    if member.expiry.present?
      member.expiry.strftime("%d/%m/%Y")
    else
      "LIFE"
    end
  end

  def list_text(member)
    return "#{member_name(member)} (#{member.graduation_year}) - #{member_expiry(member)}"
  end
end

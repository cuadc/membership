module MemberHelper
  def member_expiry(member)
    if member.expiry.present?
      member.expiry.strftime("%d/%m/%Y")
    else
      "LIFE"
    end
  end

  def member_index_text(member)
    return "#{member.name} (#{member.graduation_year}) - #{member_description(member)}"
  end

  def member_description(member)
    return member.type.name if member.type.id == 999
    if member.expiry.present?
      "#{member.type.name} Member until #{member.expiry.strftime("%d/%m/%Y")}"
    else
      "#{member.type.name} Member for life"
    end
  end

  def expiry_text(member)
    if member.expiry
      member.expiry.strftime("Expires on %a #{member.expiry.day.ordinalize} %b %Y")
    end
  end
end

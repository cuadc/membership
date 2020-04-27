module MemberHelper
  def member_expiry(member)
    if member.expiry.present?
      member.expiry.strftime("%d/%m/%Y")
    else
      "LIFE"
    end
  end

  def list_text(member)
    return "#{member.full_name} (#{member.graduation_year}) - #{member_expiry(member)}"
  end

  def expiry_text(member)
    if member.expiry
      member.expiry.strftime("Expires on %a #{member.expiry.day.ordinalize} %b %Y")
    end
  end
end

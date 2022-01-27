module MemberHelper
  def member_expiry(member)
    if member.canned_expiry.present?
      member.canned_expiry.strftime("%d/%m/%Y")
    else
      "LIFE"
    end
  end

  def expiry_text(member)
    if member.canned_expiry
      member.canned_expiry.strftime("Expires on %a #{member.canned_expiry.day.ordinalize} %b %Y")
    end
  end
end

module MemberHelper
    def list_text(member)
      name_part = "#{member.last_name}, #{member.other_names}"
      expiry_part = if member.expiry.present?
        member.expiry.strftime("%d/%m/%Y")
      else
        "LIFE"
      end
      return "#{name_part} (#{member.graduation_year}) - #{expiry_part}"
    end
  end

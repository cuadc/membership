class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type

  def full_name
    if other_names.nil?
      last_name
    else
      "#{other_names} #{last_name}"
    end
  end

  def get_inst
    return institution.name
  end

  def get_type
    if expiry.present?
      return "Expired" if expiry < Date.today
    end
    return type.name
  end
end

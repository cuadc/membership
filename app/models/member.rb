class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type

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

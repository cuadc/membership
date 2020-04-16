class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type

  validates :primary_email, presence: true
  validates :graduation_year, presence: true
  validate :must_have_a_name

  def must_have_a_name
    if full_name.blank?
      errors.add(:base, "Member must have a name")
    end
  end

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

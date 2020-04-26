class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type

  scope :ordinary, -> { where(type: Type.find_by(name: "Ordinary")) }
  scope :not_expired, -> { where("expiry IS NULL OR expiry > ?", Date.today) }

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

  def expired?
    expiry.present? && expiry <= Date.today
  end
end

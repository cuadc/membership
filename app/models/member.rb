class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type

  scope :ordinary, -> { where(type: Type.find_by(name: "Ordinary")) }
  scope :not_expired, -> { where("expiry IS NULL OR expiry > ?", Date.today) }
  scope :not_legacy_email, -> { where("primary_email NOT LIKE 'unknown-member-email-_%@cuadc.org'") }

  before_validation :normalise_crsid

  validates :name, presence: true
  validates :primary_email, presence: true, uniqueness: true
  validates :graduation_year, presence: true

  strip_attributes

  def list_email
    if type == Type.find_by(name: "Ordinary")
      primary_email
    elsif type == Type.find_by(name: "Associate")
      if secondary_email.present?
        secondary_email
      else
        if primary_email.ends_with? "@cam.ac.uk"
          crsid + "@cantab.ac.uk"
        else
          primary_email
        end
      end
    else
      nil
    end
  end

  def expired?
    expiry.present? && expiry <= Date.today
  end

  private

  def normalise_crsid
    self.crsid = crsid.downcase unless crsid.blank?
  end
end

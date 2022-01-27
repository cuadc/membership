class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type
  has_many :purchase_ingest_items

  scope :ordinary, -> { where(type: Type.find_by(name: "Ordinary")) }
  scope :not_expired, -> { joins(:purchase_ingest_items).where('expiry IS NULL OR expiry > ? OR purchase_ingest_items.expires > ?', Date.today, Date.today) }
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

  def canned_expiry?
    purchase_ingest_items.present?
  end

  def canned_expiry
    if canned_expiry?
      if purchase_ingest_items.where(mtype: 'Life').present?
        nil
      else
        purchase_ingest_items.order(:purchased).last.expires.to_date
      end
    else
      expiry
    end
  end

  def canned_expiry=(date)
    unless canned_expiry?
      self.expiry = date
    end
  end

  def expired?
    canned_expiry.present? && canned_expiry <= Date.today
  end

  private

  def normalise_crsid
    self.crsid = crsid.downcase unless crsid.blank?
  end
end

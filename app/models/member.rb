class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :type
  has_many :purchase_ingest_items

  scope :ordinary, -> { where(type_id: 1) }
  scope :not_legacy_email, -> { where("primary_email NOT LIKE 'unknown-member-email-_%@cuadc.org'") }
  scope :not_manual_expires, -> { left_joins(:purchase_ingest_items).where('purchase_ingest_items.member_id IS NULL').where('members.expiry IS NULL OR members.expiry > ?', Date.today) }
  scope :not_canned_expires, -> { joins(:purchase_ingest_items).where('purchase_ingest_items.expires IS NULL OR purchase_ingest_items.expires > ?', Date.today) }
  scope :manual_expires_in, ->(days) { left_joins(:purchase_ingest_items).where('purchase_ingest_items.member_id IS NULL').where('members.expiry < ?', Date.today + days) }
  scope :canned_expires_in, ->(days) { joins(:purchase_ingest_items).where('purchase_ingest_items.expires < ?', Date.today + days) }

  before_validation :normalise_crsid
  validates :name, presence: true
  validates :primary_email, presence: true, uniqueness: true
  validates :graduation_year, presence: true

  strip_attributes

  def self.needs_linking
    Member.where(type_id: 999) + Member.manual_expires_in(30.days) + Member.canned_expires_in(30.days)
  end

  def list_email
    if type_id == 1 # Ordinary
      primary_email
    elsif type == 2 # Associate
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
      # We don't expect more than two or three purchase_ingest_items
      # per member, so doing the logic here is quicker than going
      # back to query the database.
      if purchase_ingest_items.select { |i| i.mtype == 'Life' }.present?
        nil
      else
        purchase_ingest_items.sort_by(&:purchased).last.expires.to_date
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

  def suspended?
    type_id == 5
  end

  def banned?
    type_id == 6
  end

  private

  def normalise_crsid
    self.crsid = crsid.downcase unless crsid.blank?
  end
end

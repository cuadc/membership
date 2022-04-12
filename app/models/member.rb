# == Schema Information
#
# Table name: members
#
#  id              :bigint           not null, primary key
#  camdram_id      :integer
#  crsid           :string(255)
#  primary_email   :string(255)      not null
#  secondary_email :string(255)
#  institution_id  :bigint
#  graduation_year :integer          not null
#  mtype_id        :bigint
#  expiry          :date
#  password        :text(65535)
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  card_issued     :date
#  inhibited       :boolean
#  notes           :text(65535)
#
class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :mtype, class_name: 'Type'
  has_many :purchase_ingest_items

  scope :ordinary, -> { where(mtype_id: 1) }
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
    interval = 30.days
    Member.where(mtype_id: 999) +
      Member.where(mtype_id: 1).manual_expires_in(interval).where('members.expiry > ?', Date.today - interval) +
      Member.where(mtype_id: 1).canned_expires_in(interval).where('purchase_ingest_items.expires > ?', Date.today - interval)
  end

  def contact_email
    if mtype_id == 2 # Associate
      if secondary_email.present?
        secondary_email
      else
        if primary_email.ends_with? "@cam.ac.uk"
          if graduation_year >= 2018
            crsid + "@cantab.ac.uk"
          else
            nil
          end
        else
          primary_email
        end
      end
    elsif mtype_id.in? [1,3,4] # Ordinary, Special, Honorary
      primary_email
    else # Suspended, Banned, Awaiting Payment
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
    mtype_id == 5
  end

  def banned?
    mtype_id == 6
  end

  private

  def normalise_crsid
    self.crsid = crsid.downcase unless crsid.blank?
  end
end

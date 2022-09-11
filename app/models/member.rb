# == Schema Information
#
# Table name: members
#
#  id              :bigint           not null, primary key
#  camdram_id      :integer
#  crsid           :string(255)
#  primary_email   :string(255)      not null
#  secondary_email :string(255)
#  institution_id  :bigint           not null
#  graduation_year :integer          not null
#  mtype_id        :bigint           not null
#  expiry          :date
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  card_issued     :date
#  inhibited       :boolean          default(FALSE), not null
#  notes           :text(65535)
#  no_mail         :boolean          default(FALSE), not null
#
class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :mtype, class_name: 'Type'
  has_many :purchase_ingest_items

  scope :ordinary, -> { where(mtype_id: 1) }
  scope :associate, -> { where(mtype_id: 2) }
  scope :honorary, -> { where(mtype_id: 4) }
  scope :graduating, -> { where(mtype_id: 1).where("graduation_year <= ?", Date.today.year) }
  scope :not_legacy_email, -> { where("primary_email NOT LIKE 'unknown-member-email-_%@cuadc.org'") }
  scope :not_manual_expires, -> { left_joins(:purchase_ingest_items).where('purchase_ingest_items.member_id IS NULL').where('members.expiry IS NULL OR members.expiry > ?', Date.today) }
  scope :not_canned_expires, -> { joins(:purchase_ingest_items).where('purchase_ingest_items.expires IS NULL OR purchase_ingest_items.expires > ?', Date.today) }
  scope :manual_expires_in, ->(days) { left_joins(:purchase_ingest_items).where('purchase_ingest_items.member_id IS NULL').where('members.expiry < ?', Date.today + days) }
  scope :canned_expires_in, ->(days) { joins(:purchase_ingest_items).where('purchase_ingest_items.expires < ?', Date.today + days) }

  attr_accessor :validate_secondary_email
  attr_accessor :validate_cam_email

  before_validation :normalise_fields
  validates :name, presence: true
  validates :crsid, presence: false, uniqueness: { allow_blank: true }
  validates :primary_email, presence: true, uniqueness: true, email: true
  validates :secondary_email, presence: false, uniqueness: { allow_blank: true }, email: true, if: -> { !validate_secondary_email }
  validates :secondary_email, presence: true, uniqueness: true, email: true, if: -> { validate_secondary_email }
  validate -> { errors.add(:secondary_email, 'needs to be different') if primary_email == secondary_email }
  validate -> { errors.add(:primary_email, 'duplicates a preexisting secondary email') if Member.where.not(id: id).find_by(secondary_email: primary_email) }
  validate -> { errors.add(:secondary_email, 'duplicates a preexisting primary email') if Member.where.not(id: id).find_by(primary_email: secondary_email) }
  validates :graduation_year, presence: true
  validate :crsid_must_be_valid
  validate :cam_email_must_be_valid, if: -> { validate_cam_email }

  strip_attributes
  has_paper_trail ignore: [:created_at, :updated_at]

  def self.needs_linking
    interval = 30.days
    Member.where(mtype_id: 999).where.not(created_at: nil) +
      Member.where(mtype_id: 1).manual_expires_in(interval).where('members.expiry > ?', Date.today - interval) +
      Member.where(mtype_id: 1).canned_expires_in(interval).where('purchase_ingest_items.expires > ?', Date.today - interval)
  end

  def contact_email
    return nil if no_mail
    if mtype_id == 2 # Associate
      if secondary_email.present?
        secondary_email.downcase
      else
        if primary_email.ends_with? "@cam.ac.uk"
          if graduation_year >= 2018
            "#{crsid}@cantab.ac.uk".downcase
          else
            nil
          end
        else
          primary_email.downcase
        end
      end
    elsif mtype_id.in? [1,3,4] # Ordinary, Special, Honorary
      primary_email.downcase
    else # Suspended, Banned, Awaiting Payment
      nil
    end
  end

  def both_emails
    return [] if no_mail
    [primary_email.downcase, secondary_email.downcase].compact.uniq
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

  def normalise_fields
    self.crsid = crsid.downcase unless crsid.blank?
    self.primary_email = primary_email.downcase unless primary_email.blank?
    self.secondary_email = secondary_email.downcase unless secondary_email.blank?
  end

  def crsid_must_be_valid
    if crsid.present?
      result = Membership::Lookup.is_student?(crsid)
      if result.nil?
        errors.add(:crsid, "couldn't be found in University Lookup")
      elsif !result
        errors.add(:crsid, "does not appear to belong to a student, according to University Lookup")
      end
    end
  end

  def cam_email_must_be_valid
    if primary_email.present? && primary_email.ends_with?("@cam.ac.uk")
      result = Membership::SmtpCallout.is_accepted?(primary_email)
      if result.nil?
        errors.add(:primary_email, "could not be determined as a valid or invalid Cambridge University email address")
      elsif !result
        errors.add(:primary_email, "does not appear to be a valid Cambridge University email address")
      end
    end
  end
end

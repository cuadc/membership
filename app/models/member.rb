# == Schema Information
#
# Table name: members
#
#  id                 :bigint           not null, primary key
#  camdram_id         :integer
#  crsid              :string(255)
#  primary_email      :string(255)      not null
#  secondary_email    :string(255)
#  institution_id     :bigint           not null
#  graduation_year    :integer          not null
#  mtype_id           :bigint           not null
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  card_issued        :date
#  inhibited          :boolean          default(FALSE), not null
#  notes              :text(65535)
#  no_mail            :boolean          default(FALSE), not null
#  needs_card         :boolean          default(FALSE), not null
#  ucam_mail_accepted :boolean
#  uuid               :string(255)      not null
#
class Member < ApplicationRecord
  belongs_to :institution
  belongs_to :mtype, class_name: 'Type'
  has_many :purchase_ingest_items, dependent: :destroy
  has_many :email_verification_tokens, dependent: :destroy
  has_one :ucam_lookup_record, dependent: :destroy

  delegate :data, to: :ucam_lookup_record, allow_nil: true, prefix: :ucam_lookup

  scope :ordinary, -> { where(mtype_id: 1) }
  scope :associate, -> { where(mtype_id: 2) }
  scope :honorary, -> { where(mtype_id: 4) }
  scope :graduating, -> { where(mtype_id: 1).where("graduation_year <= ?", Date.today.year) }
  scope :not_legacy_email, -> { where("primary_email NOT LIKE 'unknown-member-email-_%@cuadc.org'") }

  after_initialize do
    self.uuid = SecureRandom.uuid unless self.uuid
  end
  before_validation :normalise_fields
  after_commit :sync_with_sympa!

  validates :name, presence: true
  validates :crsid, presence: false, uniqueness: { allow_blank: true }
  validates :primary_email, presence: true, uniqueness: true, email: true
  validates :secondary_email, presence: false, uniqueness: { allow_blank: true }, email: true, if: -> { !CurrentRequest.is_signup? }
  validates :secondary_email, presence: true, uniqueness: true, email: true, if: -> { CurrentRequest.is_signup? }
  validates :graduation_year, presence: true
  validates :uuid, presence: true, uniqueness: true, uuid: true
  validate -> { errors.add(:secondary_email, 'needs to be different') if primary_email == secondary_email }
  validate -> { errors.add(:primary_email, 'duplicates a preexisting secondary email') if Member.where.not(id: id).find_by(secondary_email: primary_email) }
  validate -> { errors.add(:secondary_email, 'duplicates a preexisting primary email') if Member.where.not(id: id).find_by(primary_email: secondary_email) }
  validate :crsid_must_be_valid, if: -> { CurrentRequest.is_signup? }
  validate :cam_email_must_be_valid, if: -> { CurrentRequest.is_signup? }
  validate :primary_email_must_be_academic, if: -> { CurrentRequest.is_signup? }
  validate :secondary_email_must_not_be_academic, if: -> { CurrentRequest.is_signup? }

  strip_attributes
  has_paper_trail ignore: [:created_at, :updated_at]

  def self.needs_linking
    Member.where(mtype_id: 999).where.not(created_at: nil)
  end

  def contact_email
    return nil if no_mail
    if mtype_id == 2 # Associate
      if secondary_email.present?
        secondary_email.downcase
      elsif crsid_active? && ucam_mail_accepted?
        "#{crsid.downcase}@cam.ac.uk"
      else
        if primary_email == "#{crsid}@cam.ac.uk"
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
    [primary_email, secondary_email].compact.map(&:downcase).uniq
  end

  def suspended?
    mtype_id == 5
  end

  def banned?
    mtype_id == 6
  end

  def crsid_active?
    return nil unless ucam_lookup_data.present?
    !ucam_lookup_data['cancelled']
  rescue
    return nil
  end

  def ucam_student?
    return nil unless ucam_lookup_data.present?
    !ucam_lookup_data['cancelled'] && ucam_lookup_data['student']
  rescue
    return nil
  end

  def ucam_staff?
    return nil unless ucam_lookup_data.present?
    !ucam_lookup_data['cancelled'] && ucam_lookup_data['staff']
  rescue
    return nil
  end

  def ug?
    return nil unless ucam_lookup_data.present?
    ucam_lookup_data["groups"].select { |g| g["name"].end_with? "-sis-ug" }.count > 0
  rescue
    return nil
  end

  def pg?
    return nil unless ucam_lookup_data.present?
    ucam_lookup_data["groups"].select { |g| g["name"].end_with? "-sis-pg" }.count > 0
  rescue
    return nil
  end

  def sync_with_lookup!
    ::Membership::LookupSync.sync_members([self])
  end

  def sync_with_sympa!
    ::Membership::SympaSync.sync_members([self])
  end

  private

  def normalise_fields
    self.crsid = crsid.downcase unless crsid.blank?
    self.primary_email = primary_email.downcase unless primary_email.blank?
    self.secondary_email = secondary_email.downcase unless secondary_email.blank?
  end

  def crsid_must_be_valid
    if crsid.present?
      ulr = UcamLookupRecord.find_or_create_by(member: self)
      ulr.data = ::Membership::Lookup.about(crsid)
      self.ucam_lookup_record = ulr
      result = ucam_student?
      if result.nil?
        errors.add(:crsid, "couldn't be found in University Lookup")
      elsif !result
        errors.add(:crsid, "does not appear to belong to a student, according to University Lookup")
      end
    end
  end

  def cam_email_must_be_valid
    if primary_email.present? && primary_email.ends_with?("@cam.ac.uk")
      self.ucam_mail_accepted = ::Membership::SmtpCallout.is_accepted?(primary_email)
      if ucam_mail_accepted.nil?
        errors.add(:primary_email, "could not be determined as a valid or invalid Cambridge University email address")
      elsif !ucam_mail_accepted
        errors.add(:primary_email, "does not appear to be a valid Cambridge University email address")
      end
    end
  end

  def primary_email_must_be_academic
    if primary_email.present?
      unless primary_email.ends_with?(".ac.uk")
        errors.add(:primary_email, "does not appear to be an academic email address")
      end
    end
  end
end

def secondary_email_must_not_be_academic
  if secondary_email.present?
    if secondary_email.ends_with?(".ac.uk") || secondary_email.ends_with?(".edu")
      errors.add(:secondary_email, "appears to be an academic email address")
    end
  end
end

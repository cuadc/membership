# == Schema Information
#
# Table name: email_verification_tokens
#
#  id         :bigint           not null, primary key
#  email      :string(255)      not null
#  uuid       :string(255)      not null
#  verified   :boolean          default(FALSE), not null
#  member_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EmailVerificationToken < ApplicationRecord
  belongs_to :member
  validates :email, presence: true
  validates :uuid, presence: true
  strip_attributes

  def self.generate(email, member_id)
    EmailVerificationToken.create! do |t|
      t.email = email
      t.uuid = SecureRandom.uuid
      t.verified = false
      t.member_id = member_id
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  email      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sysop      :boolean          default(FALSE), not null
#  active     :boolean          default(TRUE), not null
#
class User < ApplicationRecord
  has_many :sessions, dependent: :delete_all
  has_many :provider_accounts, dependent: :delete_all

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  strip_attributes

  def self.from_omniauth(auth_hash)
    provider = auth_hash['provider'].to_s
    uid = auth_hash['uid'].to_s
    account = ProviderAccount.find_by(provider: provider, uid: uid)
    account.try(:user)
  end
end

class User < ApplicationRecord
  has_many :provider_accounts, dependent: :delete_all

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(auth_hash)
    provider = auth_hash['provider'].to_s
    uid = auth_hash['uid'].to_s
    account = ProviderAccount.find_by(provider: provider, uid: uid)
    account.try(:user)
  end
end

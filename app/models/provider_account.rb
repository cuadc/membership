# == Schema Information
#
# Table name: provider_accounts
#
#  id         :bigint           not null, primary key
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProviderAccount < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
end

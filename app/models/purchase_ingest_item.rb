# == Schema Information
#
# Table name: purchase_ingest_items
#
#  id         :bigint           not null, primary key
#  cid        :string(255)      not null
#  name       :string(255)      not null
#  email      :string(255)      not null
#  mtype      :string(255)      not null
#  first      :boolean          not null
#  purchased  :datetime         not null
#  starts     :datetime         not null
#  expires    :datetime
#  member_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PurchaseIngestItem < ApplicationRecord
  belongs_to :member, optional: true

  validates :cid, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :mtype, presence: true
  validates :purchased, presence: true
  validates :starts, presence: true

  strip_attributes
  has_paper_trail on: [:update, :destroy], ignore: [:created_at, :updated_at]

  def self.needs_linking
    PurchaseIngestItem.where(member: nil).where('purchased > ?', Date.today - 60.days).order(:purchased)
  end
end

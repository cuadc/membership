class PurchaseIngestItem < ApplicationRecord
  belongs_to :member, optional: true

  validates :cid, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :mtype, presence: true
  validates :purchased, presence: true
  validates :starts, presence: true

  strip_attributes

  def self.needs_linking
    PurchaseIngestItem.where(member: nil).where('purchased > ?', Date.today - 60.days).order(:purchased)
  end

  def renewed?
    if first?
      ''
    else
      'Yes'
    end
  end
end

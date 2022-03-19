class ShowContactDetails < ApplicationRecord
  validates :camdram_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :email, presence: true
end

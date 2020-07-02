class Type < ApplicationRecord
  has_many :members
  validates :name, presence: true
  strip_attributes
end

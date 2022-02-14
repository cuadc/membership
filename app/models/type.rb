class Type < ApplicationRecord
  has_many :members, foreign_key: :mtype_id
  validates :name, presence: true
  strip_attributes
end

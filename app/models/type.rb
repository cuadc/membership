# == Schema Information
#
# Table name: types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#
class Type < ApplicationRecord
  has_many :members, foreign_key: :mtype_id
  validates :name, presence: true
  strip_attributes
end

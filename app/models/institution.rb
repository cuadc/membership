# == Schema Information
#
# Table name: institutions
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#
class Institution < ApplicationRecord
  has_many :members
  validates :name, presence: true
  strip_attributes
end

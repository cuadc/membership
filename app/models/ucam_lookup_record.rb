# == Schema Information
#
# Table name: ucam_lookup_records
#
#  id         :bigint           not null, primary key
#  member_id  :bigint           not null
#  data       :text(4294967295) not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UcamLookupRecord < ApplicationRecord
  belongs_to :member

  validates :data, presence: true
  serialize :data, type: Hash, coder: JSON
end

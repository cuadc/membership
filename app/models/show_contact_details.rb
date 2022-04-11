# == Schema Information
#
# Table name: show_contact_details
#
#  id         :bigint           not null, primary key
#  camdram_id :integer          not null
#  email      :string(255)      not null
#
class ShowContactDetails < ApplicationRecord
  validates :camdram_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :email, presence: true
end

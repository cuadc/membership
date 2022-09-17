class AddNeedsCardToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :needs_card, :bool, default: false, null: false
    Member.where(mtype_id: 1, card_issued: nil).where.not(created_at: nil).update_all(needs_card: true)
  end
end

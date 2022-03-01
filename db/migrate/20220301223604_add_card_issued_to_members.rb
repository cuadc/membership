class AddCardIssuedToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :card_issued, :date
  end
end

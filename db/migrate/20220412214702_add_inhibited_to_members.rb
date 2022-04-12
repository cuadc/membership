class AddInhibitedToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :inhibited, :bool, default: false, null: false
  end
end

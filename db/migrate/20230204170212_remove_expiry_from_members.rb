class RemoveExpiryFromMembers < ActiveRecord::Migration[6.1]
  def change
    remove_column :members, :expiry, :date
  end
end

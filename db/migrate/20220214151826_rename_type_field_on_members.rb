class RenameTypeFieldOnMembers < ActiveRecord::Migration[6.1]
  def change
    rename_column :members, :type_id, :mtype_id
  end
end

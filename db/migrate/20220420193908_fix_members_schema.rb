class FixMembersSchema < ActiveRecord::Migration[6.1]
  def change
    remove_column :members, :password
    change_column_null :members, :institution_id, false
    change_column_null :members, :mtype_id, false
  end
end

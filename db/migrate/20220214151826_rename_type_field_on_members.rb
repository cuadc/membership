class RenamemtypeFieldOnMembers < ActiveRecord::Migration[6.1]
  def change
    rename_column :members, :mtype_id, :mtype_id
  end
end

class RenamePaperTrailColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :versions, :object, :old_object
    rename_column :versions, :object_changes, :old_object_changes
    rename_column :versions, :new_object, :object
    rename_column :versions, :new_object_changes, :object_changes
  end
end

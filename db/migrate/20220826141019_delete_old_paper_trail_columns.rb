class DeleteOldPaperTrailColumns < ActiveRecord::Migration[6.1]
  def up
    remove_column :versions, :object
    remove_column :versions, :object_changes
    rename_column :versions, :new_object, :object
    rename_column :versions, :new_object_changes, :object_changes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

class AddNewPaperTrailColumns < ActiveRecord::Migration[6.1]
  # The largest text column available in all supported RDBMS.
  # See `create_versions.rb` for details.
  TEXT_BYTES = 1_073_741_823

  def change
    add_column :versions, :new_object, :text, limit: TEXT_BYTES
    add_column :versions, :new_object_changes, :text, limit: TEXT_BYTES
  end
end

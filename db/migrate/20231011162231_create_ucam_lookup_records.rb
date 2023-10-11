class CreateUcamLookupRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :ucam_lookup_records do |t|
      t.references :member, index: { unique: true }, foreign_key: true, null: false
      t.longtext :data, null: false
      t.timestamps
    end
    remove_column :members, :ucam_lookup_data, :longtext
  end
end

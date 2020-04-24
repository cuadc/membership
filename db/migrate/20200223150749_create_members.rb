class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.integer :camdram_id
      t.string :crsid
      t.string :last_name
      t.string :other_names
      t.string :primary_email, null: false
      t.string :secondary_email
      t.belongs_to :institution
      t.integer :graduation_year, null: false
      t.belongs_to :type
      t.date :expiry
      t.text :password
    end
    add_index :members, :camdram_id, unique: true
    add_index :members, :crsid, unique: true
    add_index :members, :primary_email, unique: true
    add_index :members, :secondary_email, unique: true
  end
end

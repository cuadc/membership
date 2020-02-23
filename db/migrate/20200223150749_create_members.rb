class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.integer :camdram_id
      t.string :crsid
      t.string :last_name
      t.string :other_names
      t.string :primary_email
      t.string :secondary_email
      t.belongs_to :institution
      t.integer :graduation_year
      t.belongs_to :type
      t.date :expiry
      t.text :password
    end
  end
end

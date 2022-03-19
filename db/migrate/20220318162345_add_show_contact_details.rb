class AddShowContactDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :show_contact_details do |t|
      t.integer :camdram_id, null: false
      t.string :email, null: false
    end
  end
end

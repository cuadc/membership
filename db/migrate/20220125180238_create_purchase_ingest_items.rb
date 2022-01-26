class CreatePurchaseIngestItems < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_ingest_items do |t|
      t.string :cid, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :mtype, null: false
      t.boolean :first, null: false
      t.timestamp :purchased, null: false
      t.timestamp :starts, null: false
      t.timestamp :expires
      t.references :member, foreign_key: true, null: true

      t.timestamps
    end
  end
end

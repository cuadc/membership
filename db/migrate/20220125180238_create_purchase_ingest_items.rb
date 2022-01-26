class CreatePurchaseIngestItems < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_ingest_items do |t|
      t.string :name
      t.string :email
      t.string :type
      t.timestamp :purchased
      t.timestamp :starts
      t.timestamp :expires

      t.timestamps
    end
  end
end

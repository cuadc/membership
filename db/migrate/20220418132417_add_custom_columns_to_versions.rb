class AddCustomColumnsToVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :item_subtype, :string, null: true
    add_column :versions, :request_uuid, :string, null: false
    add_column :versions, :session, :bigint, null: true
    add_column :versions, :ip, :string, null: false
    add_column :versions, :user_agent, :string, null: false
  end
end

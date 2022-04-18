class AddCustomColumnsToVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :item_subtype, :string
    add_column :versions, :request_uuid, :string
    add_column :versions, :session, :bigint
    add_column :versions, :ip, :string
    add_column :versions, :user_agent, :string
  end
end

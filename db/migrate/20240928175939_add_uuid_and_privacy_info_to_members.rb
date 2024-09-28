class AddUuidAndPrivacyInfoToMembers < ActiveRecord::Migration[7.1]
  def up
    ActiveRecord::Base.transaction do
      add_column :members, :uuid, :string
      Member.all.each { |m| m.update(uuid: SecureRandom.uuid) }
      add_index :members, :uuid, unique: true
      change_column_null :members, :uuid, false
    end
  end

  def down
    remove_column :members, :uuid
  end
end

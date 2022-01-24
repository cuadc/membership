class AddTimestamps < ActiveRecord::Migration[6.1]
  def change
    # We don't add NOT NULL constraints here because of historical reasons.
    add_column :institutions, :created_at, :datetime
    add_column :institutions, :updated_at, :datetime

    add_column :types, :created_at, :datetime
    add_column :types, :updated_at, :datetime

    add_column :members, :created_at, :datetime
    add_column :members, :updated_at, :datetime
  end
end

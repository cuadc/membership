class AddSysopToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :sysop, :bool, default: false, null: false
  end
end

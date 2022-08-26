class AddSysopToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :sysop, :bool, default: false, null: false
    User.find_by(email: "charlie@charliejonas.co.uk").try(:update!, {sysop: true})
  end
end

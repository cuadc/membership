class AddNoMailToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :no_mail, :bool, default: false, null: false
  end
end

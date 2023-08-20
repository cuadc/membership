class AddMemoisedDataToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :ucam_lookup_data, :text
    add_column :members, :ucam_mail_accepted, :bool
  end
end

class AddNotesToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :notes, :text
  end
end

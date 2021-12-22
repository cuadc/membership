class MergeFirstAndLastNames < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      add_column :members, :name, :string
      Member.all.each do |m|
        m.update!(name: "#{m.other_names} #{m.last_name}".strip)
      end
      remove_column :members, :last_name
      remove_column :members, :other_names
    end
  end
end

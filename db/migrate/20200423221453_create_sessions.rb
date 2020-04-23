class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true, null: false
      t.datetime :login_at, null: false
      t.datetime :expires_at, null: false
      t.string :ip, null: false
      t.string :user_agent, null: false
    end
  end
end

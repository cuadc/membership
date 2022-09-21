class CreateEmailVerificationToken < ActiveRecord::Migration[6.1]
  def change
    create_table :email_verification_tokens do |t|
      t.string :email, null: false
      t.string :uuid, null: false
      t.boolean :verified, default: false, null: false
      t.references :member, foreign_key: true, null: false
      t.timestamps
    end
  end
end

class CreateSentMail < ActiveRecord::Migration[6.1]
  def change
    create_table :sent_mails do |t|
      t.string :mailer_class, null: false
      t.string :mailer_method, null: false
      t.string :address, null: false
      t.timestamp :submitted, null: false
    end
  end
end

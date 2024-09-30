class AddToCcBccToSentMails < ActiveRecord::Migration[7.1]
  def change
    add_column :sent_mails, :to, :longtext
    add_column :sent_mails, :cc, :longtext
    add_column :sent_mails, :bcc, :longtext
    change_column_null :sent_mails, :address, true
  end
end

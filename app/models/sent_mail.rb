# == Schema Information
#
# Table name: sent_mails
#
#  id            :bigint           not null, primary key
#  mailer_class  :string(255)      not null
#  mailer_action :string(255)      not null
#  address       :string(255)
#  submitted     :datetime         not null
#  to            :text(4294967295)
#  cc            :text(4294967295)
#  bcc           :text(4294967295)
#
class SentMail < ApplicationRecord; end

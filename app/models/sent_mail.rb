# frozen_string_literal: true

# == Schema Information
#
# Table name: sent_mails
#
#  id            :bigint           not null, primary key
#  mailer_class  :string(255)      not null
#  mailer_action :string(255)      not null
#  address       :string(255)      not null
#  submitted     :datetime         not null
#
class SentMail < ApplicationRecord; end

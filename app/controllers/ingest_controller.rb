class IngestController < ApplicationController
  skip_before_action :check_user!
  skip_before_action :verify_authenticity_token
  before_action :check_token!

  def purchase
    # Strip the BOM.
    str = request.body.string.force_encoding('utf-8').sub("\xEF\xBB\xBF", '')
    CSV.parse(str, headers: true).each do |row|
      unless PurchaseIngestItem.find_by(cid: row["Customer Id"], purchased: row["Purchase Date"])
        PurchaseIngestItem.create do |item|
          item.cid = row["Customer Id"]
          item.name = "#{row["First Name"]} #{row["Last Name"]}" # Sigh, Spektrix.
          item.email = row["Email Address"]
          item.mtype = row["Membership Name"].sub('CUADC ', '')
          item.first = row["First Of This Membership"]
          item.purchased = row["Purchase Date"]
          item.starts = row["Start Date"]
        end
      end
    end
  end

  private

  def check_token!
    token = request.headers["X-Membership-Ingest-Token"]
    unless ENV['INGEST_TOKEN'].present? && token == ENV['INGEST_TOKEN']
      render plain: 'Bad credentials', status: 403
    end
    PaperTrail.request.whodunnit = 'Spektrix Auto-Ingest'
  end
end

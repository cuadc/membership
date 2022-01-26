class IngestController < ApplicationController
  skip_before_action :check_user!
  skip_before_action :verify_authenticity_token
  before_action :check_token!

  def expiry; end

  def purchase
    # Strip the BOM.
    str = request.body.string.force_encoding('utf-8').sub("\xEF\xBB\xBF", '')
    CSV.parse(str, headers: true).each do |row|
      PurchaseIngestItem.create! do |item|
        item.name = "#{row["First Name"]} #{row["Last Name"]}"
        item.email = row["Email Address"]
        item.type = row["Membership Name"]
        item.purchased = row["Purchase Date"]
        item.starts = row["Start Date"]
        item.expires = row["Expiry Date"]
      end
    end
  end

  private

  def check_token!
    token = request.headers["X-Membership-Ingest-Token"]
    unless ENV['INGEST_TOKEN'].present? && token == ENV['INGEST_TOKEN']
      render plain: 'Bad credentials', status: 403
    end
  end
end

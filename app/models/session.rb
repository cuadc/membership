class Session < ApplicationRecord
  belongs_to :user

  validates :login_at, presence: true
  validates :expires_at, presence: true
  validates :ip, presence: true

  def self.from_user_and_request(user, request)
    login_at = Time.zone.now
    expires_at = login_at + 4.hours
    ip = request.remote_ip
    user_agent = request.user_agent
    create!(user: user, login_at: login_at, expires_at: expires_at, ip: ip, user_agent: user_agent)
  end

  def expired?
    Time.zone.now >= self.expires_at
  end
end

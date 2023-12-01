class ApiKey < ApplicationRecord
  validates :access_token, presence: true, uniqueness: true

  before_validation :generate_access_token

  encrypts :access_token, deterministic: true

  private

  def generate_access_token
    self.access_token = Digest::MD5.hexdigest(SecureRandom.hex)
  end
end

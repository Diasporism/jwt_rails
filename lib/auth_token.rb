module AuthToken
  require 'jwt'

  def self.issue_token(payload)
    # Set expiration to 72 hours.
    JWT.encode(payload, Rails.application.secrets.secret_key_base, claims: { exp: 259200 })
  end

  def self.valid?(token)
    begin
      JWT.decode(token, Rails.application.secrets.secret_key_base)
    rescue
      false
    end
  end
end

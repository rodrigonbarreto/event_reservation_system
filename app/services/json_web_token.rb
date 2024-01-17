# frozen_string_literal: true

class JsonWebToken
  SECRET = 'secret-key'
  ENCRYPTION = 'HS256'
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature
    nil
  rescue StandardError
    nil
  end
end

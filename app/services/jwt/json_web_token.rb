# frozen_string_literal: true

module Jwt
  class JsonWebToken
    # SECRET = Rails.application.credentials.secret_key_base
    SECRET = "secret-key" # usar algum codigo no secrets ou algo mais seguro
    ENCRYPTION = "HS256"
    def self.encode(payload, exp = 120.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET)
    rescue JWT::EncodeError => e
      Rails.logger.error("JWT Encode Error: #{e.message}")
    end

    def self.decode(token)
      body = JWT.decode(token, SECRET)[0]
      ActiveSupport::HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature, JWT::DecodeError => e
      Rails.logger.error("JWT Encode Error: #{e.message}")
      nil
    end
  end
end

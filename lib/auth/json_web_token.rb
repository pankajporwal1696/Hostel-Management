module Auth
  class JsonWebToken
    SECRET_KEY = Rails.application.credentials.dig(:secret_key_base) || Rails.application.secrets.secret_key_base
    raise 'Missing secret key for JWT' unless SECRET_KEY.present?

    def self.encode(payload, exp = 24.hours.from_now)
      payload[:jti] = SecureRandom.uuid
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      payload = HashWithIndifferentAccess.new(decoded)

      if JwtDenylist.exists?(jti: payload[:jti])
        raise JWT::DecodeError, 'Token has been blacklisted'
      end

      payload
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error("JWT Error: #{e.message}")
      raise e
    end
  end
end

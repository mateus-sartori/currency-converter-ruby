class JwtAuthService
  def self.decode_jwt_payload(token)
    JWT.decode(token.split[1], ENV.fetch('DEVISE_JWT_SECRET_KEY', nil)).first
  end

  def self.token_is_in_denylist?(jwt_payload)
    JwtDenylist.find_by(jti: jwt_payload['jti'])
  end

  def self.find_user_by_jwt_payload(jwt_payload)
    User.find_by(id: jwt_payload['sub'])
  end
end

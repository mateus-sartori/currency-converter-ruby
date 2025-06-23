class ApplicationController < ActionController::API
  before_action :authenticate_user, unless: -> { devise_controller? || verify_token? }

  private

  def authenticate_user
    return render_unauthorized if invalid_token?

    @current_user = user_from_valid_token
    render_unauthorized unless @current_user
  rescue JWT::VerificationError, JWT::DecodeError
    render_unauthorized
  end

  def invalid_token?
    token.nil? || token_payload.nil? || token_in_denylist?
  end

  def token
    request.headers['Authorization']
  end

  def token_payload
    return if token == 'null'

    @token_payload ||= JwtAuthService.decode_jwt_payload(token)
  end

  def token_in_denylist?
    JwtAuthService.token_is_in_denylist?(token_payload)
  end

  def user_from_valid_token
    JwtAuthService.find_user_by_jwt_payload(token_payload)
  end

  def render_unauthorized
    render status: :unauthorized
  end

  def devise_controller?
    self.class.to_s.start_with?('Devise::') || self.class.to_s.start_with?('DeviseOverride::')
  end

  def verify_token?
    self.class.to_s.start_with?('Token') && params[:action] == 'verify_token'
  end
end

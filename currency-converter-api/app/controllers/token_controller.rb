class TokenController < ApplicationController
  before_action :set_token, only: %i[verify_token]

  def validate
    render status: :ok
  end

  def verify_token
    user = User.find_by(confirmation_token: @token)

    return render status: :ok if user.present?

    render status: :unauthorized
  end

  private

  def set_token
    @token = params[:token]
  end
end

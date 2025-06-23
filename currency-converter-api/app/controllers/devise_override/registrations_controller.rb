class DeviseOverride::RegistrationsController < Devise::RegistrationsController
  before_action :user_params, only: [:create]

  respond_to :json

  def create
    @user = User.new(user_params)

    if @user.save
      render status: :created
    else
      render status: :bad_request, json: { message: @user.errors.full_messages.join(', ') }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: {
      message: 'Signed up sucessfully.',
      user: current_user
    }, status: :ok
  end

  def register_failed
    render json: { message: 'Something went wrong' }, status: :unprocessable_entity
  end
end

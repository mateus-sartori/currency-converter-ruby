class DeviseOverride::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      user: resource
    }, status: :ok
  end

  def respond_to_on_destroy
    render status: :no_content
  end

  def log_out_failure
    render status: :unauthorized
  end
end

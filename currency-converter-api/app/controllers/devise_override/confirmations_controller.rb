class DeviseOverride::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    yield resource if block_given?

    if resource.errors.empty?
      host = ENV.fetch('FRONT_HOST')

      redirect_to "http://#{host}/confirmed-account?token=#{params[:confirmation_token]}",
                  allow_other_host: true
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end
end

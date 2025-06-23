class DeviseOverride::PasswordsController < Devise::PasswordsController
  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]

    host = ENV.fetch('FRONT_HOST')
    url = "http://#{host}/reset-password?reset_password_token=#{params[:reset_password_token]}"

    redirect_to url, allow_other_host: true
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params)
    yield resource if block_given?

    if resource.id.nil?
      return render json: { message: 'Token para redefinição de senha inválido' },
                    status: :gone
    end

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: { message: 'Senha alterada com sucesso!' },
             status: :ok
    else
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end
end

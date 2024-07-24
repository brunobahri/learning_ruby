class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, if: :json_request?

  respond_to :json

  # Sobrescreve a ação new para retornar um erro em requisições GET
  def new
    render json: { error: 'Method not allowed' }, status: :method_not_allowed
  end

  def create
    Rails.logger.debug "Parameters received: #{params.inspect}"
    user = User.find_by(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      sign_in(user)
      render json: { user: user, token: current_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    Rails.logger.debug "Current user: #{current_user.inspect}"
    sign_out(current_user)
    render json: { message: 'User signed out successfully' }, status: :ok
  end

  protected

  def json_request?
    Rails.logger.debug "Request format: #{request.format}"
    request.format.json?
  end

  def respond_with(resource, _opts = {})
    Rails.logger.debug "Authenticated user: #{resource.inspect}"
    Rails.logger.debug "JWT Token: #{current_token}"
    render json: { user: resource, token: current_token }
  end

  def respond_to_on_destroy
    Rails.logger.debug "User signed out successfully"
    head :no_content
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end
end

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, if: :json_request?

  respond_to :json

  protected

  def json_request?
    Rails.logger.debug "Request format: #{request.format}"
    request.format.json?
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

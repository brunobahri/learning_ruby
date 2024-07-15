class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :debug_request, if: :json_request?

  respond_to :json

  protected

  def json_request?
    Rails.logger.debug "Request format: #{request.format}"
    request.format.json?
  end

  def debug_request
    Rails.logger.debug "Skipping CSRF for JSON request"
  end
end

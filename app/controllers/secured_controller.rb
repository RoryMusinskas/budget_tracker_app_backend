class SecuredController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'openssl'
  require 'json'
  before_action :authorize_request
  # Created class attribute, this is set when the authentication is successful
  class_attribute :current_user, :current_user_id

  private

  # Run the authorization process on the request coming in
  def authorize_request
    @decoded_request = AuthorizationService.new(request.headers).authenticate_request!
    @current_user = @decoded_request[0]['sub']
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end
end


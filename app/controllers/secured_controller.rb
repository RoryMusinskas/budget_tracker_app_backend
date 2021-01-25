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
    set_class_attribute
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end
  
  # Once we have user data, set the Class attributes to pass to children
  def set_class_attribute
    # Update these details only when the user endpoint is checked to see if the user exists or not (This is ran every refresh)
    if params[:controller] == 'users'
      SecuredController.current_user = params[:user][:email]
      SecuredController.current_user_id = User.where(email: params[:user][:sub]) # Changed [:email].ids[0] as [:sub] to set user.sub from auth0
    end
  end
end


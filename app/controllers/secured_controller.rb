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
    # call the get_user_details function
    get_user_details
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end
  
  # Get the user details from the Auth0 Management endpoint 
  def get_user_details
    # Get the sub from the user request
    user_sub = @decoded_request[0]['sub']

    # Encode the url for better processing
    encoded_url = URI.encode("https://dev-2fj3w1-h.au.auth0.com/api/v2/users/#{user_sub}")
    url = URI.parse(encoded_url)

    # Make a new HTTP request to Auth0 user endpoint
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Bearer #{params['UserAccessToken']}"

    response = http.request(request)
    user = JSON.parse(response.body)
    
    # Once we have user data, set the Class attributes to pass to children
    set_class_attribute(user)

  end
  
  # Once we have user data, set the Class attributes to pass to children
  def set_class_attribute(user)
    # Update these details only when the user endpoint is checked to see if the user exists or not (This is ran every refresh)
    if params[:controller] == 'users'
      SecuredController.current_user = user['email']
      SecuredController.current_user_id = User.where(email: SecuredController.current_user).ids[0]
    else
      @current_user = SecuredController.current_user
    end
  end
end


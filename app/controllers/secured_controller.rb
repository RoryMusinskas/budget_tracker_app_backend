class SecuredController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'openssl'
  require 'json'
  before_action :authorize_request

  private

  def authorize_request
    @decoded_request = AuthorizationService.new(request.headers).authenticate_request!
    get_user_details
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end
  
  def get_user_details
    user_sub = @decoded_request[0]['sub']

    @authorization_token = get_authorizaton_token

    encoded_url = URI.encode("https://dev-2fj3w1-h.au.auth0.com/api/v2/users/#{user_sub}")
    url = URI.parse(encoded_url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Bearer #{params['UserAccessToken']}"

    response = http.request(request)
    user = JSON.parse(response.body)
    @current_user = user['email']
  end
  
  def get_authorizaton_token
    @headers = request.headers
    if @headers['Authorization'].present?
      @headers['Authorization'].split(' ').last
    end
  end
end

require 'rails_helper'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'

RSpec.describe "/shares", type: :request do

# Make request to auth0 to get a test token to use for the valid header
url = URI("#{Rails.application.credentials.auth0[:domain]}oauth/token")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(url)
request["content-type"] = 'application/json'
request.body = "{\"client_id\":\"#{Rails.application.credentials.auth0[:test_client_id]}\",\"client_secret\":\"#{Rails.application.credentials.auth0[:test_client_secret]}\",\"audience\":\"#{Rails.application.credentials.auth0[:api_identifier]}\",\"grant_type\":\"client_credentials\"}"
token_response = http.request(request)
data = JSON.parse(token_response.body)
access_token = data['access_token']

  let(:valid_attributes) {
    {description: 'description', symbol: 'description', user_sub: 'description'}
  }

  let(:invalid_attributes) {
    {description: 1, symbol: nil, user_sub: nil}
  }

  let(:valid_headers){
    {
      Authorization: access_token
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Share.create! valid_attributes
      get shares_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      share = Share.create! valid_attributes
      get share_url(share.attributes['id']), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Share" do
        expect {
          post shares_url,
               params: { share: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Share, :count).by(1)
      end

      it "renders a JSON response with the new share" do
        post shares_url,
             params: { share: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Share" do
        expect {
          post shares_url,
               params: { share: invalid_attributes }, as: :json
        }.to change(Share, :count).by(0)
      end

      it "renders a JSON response with errors for the new share" do
        post shares_url,
             params: { share: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {description: 'update', symbol: 'update', user_sub: 'update'}
      }

      it "updates the requested share" do
        share = Share.create! valid_attributes
        patch share_url(share),
              params: { share: new_attributes }, headers: valid_headers, as: :json
        share.reload
        expect(share.attributes['description']).to eq('update')
        expect(share.attributes['symbol']).to eq('update')
        expect(share.attributes['user_sub']).to eq('update')
      end

      it "renders a JSON response with the share" do
        share = Share.create! valid_attributes
        patch share_url(share),
              params: { share: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the share" do
        share = Share.create! valid_attributes
        patch share_url(share),
              params: { share: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested share" do
      share = Share.create! valid_attributes
      expect {
        delete share_url(share), headers: valid_headers, as: :json
      }.to change(Share, :count).by(-1)
    end
  end
end


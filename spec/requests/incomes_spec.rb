require 'rails_helper'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'

RSpec.describe "Income Request", type: :request do

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

  let(:category_attributes){
    {description: 'category'}
  }
  let(:valid_attributes) {
      category = Category.create! category_attributes 
      {description: 'description', amount: 100, category_id: category.attributes['id'], user_sub: 'description', title: 'title', date: '02/02/2021'}
  }

  let(:invalid_attributes) {
    {description: 1, amount: nil, category_id: nil, user_sub: nil}
  }

  let(:valid_headers){
    {
      Authorization: access_token 
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Income.create! valid_attributes
      get incomes_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      income = Income.create! valid_attributes
      get income_url(income.attributes['id']), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Income" do
        expect {
          post incomes_url,
               params: { income: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Income, :count).by(1)
      end

      it "renders a JSON response with the new income" do
        post incomes_url,
             params: { income: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Income" do
        expect {
          post incomes_url,
               params: { income: invalid_attributes }, as: :json
        }.to change(Income, :count).by(0)
      end

      it "renders a JSON response with errors for the new income" do
        post incomes_url,
             params: { income: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {description: 'update', amount: 50, user_sub: 'update'}
      }

      it "updates the requested income" do
        income = Income.create! valid_attributes
        patch income_url(income),
              params: { income: new_attributes }, headers: valid_headers, as: :json
        income.reload
        expect(income.attributes['description']).to eq('update')
        expect(income.attributes['amount']).to eq(50)
        expect(income.attributes['user_sub']).to eq('update')
      end

      it "renders a JSON response with the income" do
        income = Income.create! valid_attributes
        patch income_url(income),
              params: { income: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the income" do
        income = Income.create! valid_attributes
        patch income_url(income),
              params: { income: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested income" do
      income = Income.create! valid_attributes
      expect {
        delete income_url(income), headers: valid_headers, as: :json
      }.to change(Income, :count).by(-1)
    end
  end
end


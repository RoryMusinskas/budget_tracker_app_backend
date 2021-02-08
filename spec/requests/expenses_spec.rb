require 'rails_helper'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'


RSpec.describe "Expenses Request", type: :request do

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
      {description: 'description', amount: 100, category_id: category.attributes['id'], user_sub: 'description', title: 'title', date: '04/02/2021'}
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
      Expense.create! valid_attributes
      get expenses_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      expense = Expense.create! valid_attributes
      get expense_url(expense.attributes['id']), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Expense" do
        expect {
          post expenses_url,
               params: { expense: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Expense, :count).by(1)
      end

      it "renders a JSON response with the new expense" do
        post expenses_url,
             params: { expense: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Expense" do
        expect {
          post expenses_url,
               params: { expense: invalid_attributes }, as: :json
        }.to change(Expense, :count).by(0)
      end

      it "renders a JSON response with errors for the new expense" do
        post expenses_url,
             params: { expense: invalid_attributes }, headers: valid_headers, as: :json
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

      it "updates the requested expense" do
        expense = Expense.create! valid_attributes
        patch expense_url(expense),
              params: { expense: new_attributes }, headers: valid_headers, as: :json
        expense.reload
        expect(expense.attributes['description']).to eq('update')
        expect(expense.attributes['amount']).to eq(50)
        expect(expense.attributes['user_sub']).to eq('update')
      end

      it "renders a JSON response with the expense" do
        expense = Expense.create! valid_attributes
        patch expense_url(expense),
              params: { expense: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the expense" do
        expense = Expense.create! valid_attributes
        patch expense_url(expense),
              params: { expense: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested expense" do
      expense = Expense.create! valid_attributes
      expect {
        delete expense_url(expense), headers: valid_headers, as: :json
      }.to change(Expense, :count).by(-1)
    end
  end
end


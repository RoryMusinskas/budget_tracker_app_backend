require 'rails_helper'

RSpec.describe "/expenses", type: :request do
  let(:category_attributes){
    {description: 'category'}
  }
  let(:valid_attributes) {
      category = Category.create! category_attributes 
      {description: 'description', amount: 100, category_id: category.attributes['id'], user_sub: 'description'}
  }

  let(:invalid_attributes) {
    {description: 1, amount: nil, category_id: nil, user_sub: nil}
  }

  let(:valid_headers){
    {
      Authorization: Rails.application.credentials.auth0[:api_authorization]
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


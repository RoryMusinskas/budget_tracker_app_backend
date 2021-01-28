require 'rails_helper'

RSpec.describe "/shares", type: :request do
  let(:valid_attributes) {
    {description: 'description', symbol: 'description', user_sub: 'description'}
  }

  let(:invalid_attributes) {
    {description: 1, symbol: nil, user_sub: nil}
  }

  let(:valid_headers){
    {
      Authorization: Rails.application.credentials.auth0[:api_authorization]
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


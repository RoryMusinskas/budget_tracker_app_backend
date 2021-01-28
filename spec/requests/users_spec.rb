require 'rails_helper'
def authenticated_header
  token = Rails.application.credentials.auth0[:testing_token] 

  { 'Authorization': "Bearer #{token}" }
end

RSpec.describe "Users", type: :request do
  describe "UNAUTHENTICATED GET users#index" do
    before(:example) do 
      @first_user = create(:user)
      @second_user = create(:user)
      get users_path
      @json_response = JSON.parse(response.body)
    end

    it 'return HTTP unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'contains the correct number of responses' do
      expect(@json_response.count).to eq(1)
    end
  end

  describe "AUTHENTICATED GET users#index" do
    before(:example) do 
      @first_user = create(:user)
      @second_user = create(:user)
      get users_path, headers: authenticated_header 
      @json_response = JSON.parse(response.body)
    end

    it 'return HTTP success' do
      expect(response).to have_http_status(:success)
    end

    it 'contains the correct number of entries' do
      expect(@json_response.count).to eq(2)
    end

    it 'user contains expected attributes' do 
      expect(@json_response.first).to include({
        'id' => @first_user.id,
        'email' => @first_user.email
      })
    end
  end

  describe "UNAUTHENTICATED POST users#create" do
    context 'when the user is valid' do
      before(:example) do 
        @user_params = attributes_for(:user)
        post users_path, params: {user: @user_params}
      end

      it 'returns HTTP unauthorized' do 
        expect(response).to have_http_status(:unauthorized)
      end

    end
    context 'when the user is invalid' do
      before(:example) do 
        @user_params = attributes_for(:user, :invalid)
        post users_path, params: { user: @user_params }
        @json_response = JSON.parse(response.body)
      end

      it 'returns HTTP unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

  describe "AUTHENTICATED POST users#create" do
    context 'when the user is valid' do
      before(:example) do 
        @user_params = attributes_for(:user)
        post users_path, params: {user: @user_params}, headers: authenticated_header
      end

      it 'returns HTTP created' do 
        expect(response).to have_http_status(:created)
      end

      it 'saves the User to the database' do 
        expect(User.last.email).to eq(@user_params[:email])
      end
    end
    context 'when the user is invalid' do
      before(:example) do 
        @user_params = attributes_for(:user, :invalid)
        post users_path, params: { user: @user_params }, headers: authenticated_header
        @json_response = JSON.parse(response.body)
      end

      it 'returns HTTP unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct number of errors' do
        expect(@json_response.count).to eq(1)
      end

      it 'errors contains the correct message' do
        expect(@json_response['email'][0]).to eq("can't be blank")
      end
    end
  end
end

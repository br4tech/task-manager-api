require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # Create ele salva no banco de dados: teste de requisição precisa salvar no banco
  # Build so cria o objeto em memoria e não toca no banco de dados : teste mais leve

  let!(:user){ create(:user) }
  let(:user_id){ user.id }
  # Para evitar duplicidade
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-type' => Mime[:json].to_s
    }
  end

  before { host! 'api.taskmanager.test'}

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do

      it 'returns the user' do
        expect(json_body[:id]).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user not exist' do
      let(:user_id){ 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST/users' do

    before do
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'When the request params are valid' do
      let(:user_params){ FactoryBot.attributes_for(:user) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'return json data for the create user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end

    end

    context 'when  the request params are invalid' do
      let(:user_params){ attributes_for(:user, email: 'invalid_email@')}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the erros' do
        expect(json_body).to have_key(:errors)
      end
    end

  end

  describe 'PUT/users/:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context "when the request params are valid" do
      let(:user_params){{ email: 'new@email.com'}}

     it 'return status code 200' do
       expect(response).to have_http_status(200)
     end

     it 'returns the json data for the updated user' do
        expect(json_body[:email]).to eq(user_params[:email])
     end

    end

    context "when the request params are invalid" do
      let(:user_params){{ email: 'invalid_email@'}}

     it 'return status code 422' do
       expect(response).to have_http_status(422)
     end


     it 'return the json data for the erros' do
       expect(json_body).to have_key(:errors)
     end

    end
  end

  describe "DELETE/users/:id" do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(User.find_by(id: user.id)).to be_nil
    end

  end

end

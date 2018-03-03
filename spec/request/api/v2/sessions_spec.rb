require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  before { host! 'api.taskmanager.test'}
  let(:user){ create(:user) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-type' => Mime[:json].to_s
    }
  end

  describe 'POST/sessions' do
    before do
      post '/sessions', params: { sessions: credentials }.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials){ { email: user.email, password: '123456'}}

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the user with auth token' do
        #Recarreco o usuario,  para buscar o novo token
        user.reload
        expect(json_body[:auth_token]).to eq(user.auth_token)
      end

    end

    context 'when the credentials are incorrect' do
      let(:credentials){ { email: user.email, password: 'invalid_password'}}

      it 'return status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end

    end
  end

  describe 'DELETE /sessions/:id' do
    let(:auth_token){ user.auth_token }

    before do
       delete "/sessions/#{auth_token}",params: {}, headers: headers
    end

    it 'returns satatus code 201' do
      # Verifico se o retorno e vazio 204
       expect(response).to have_http_status(204)
    end

    it 'changes the user auth token' do
      # Espero que não exita nenhuma usuario com esse token no banco
       expect(User.find_by(auth_token: auth_token)).to be_nil
    end

  end
end

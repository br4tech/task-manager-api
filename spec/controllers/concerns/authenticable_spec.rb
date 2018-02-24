require 'rails_helper'

RSpec.describe Authenticable do

    # Simulando um controller, em outras palavras controller anônimo
    controller(ApplicationController) do
        include Authenticable
    end

    # Neste caso o subjetct passa a utilizar o controller anônimo: ApplicationController
    let(:app_controller){ subject }

    describe '#current_user' do

        let(:user){ create(:user) }
        before do
         # Mock elemento dublê Simulando o retorno do authorization
         req = double(:headers => { 'Authorization' => user.auth_token })
         # Quando alguem pedir um request, retorna o req acima, força o retorno
         allow(app_controller).to receive(:request).and_return(req)
        end

        it 'return the user from the authorization header' do
          expect(app_controller.current_user).to eq(user)
        end
    end

    describe '#authenticate_with_token!' do
      controller do
        before_action :authenticate_with_token!
        # Actionb para testar se esta valindando o usuario
        def restricted_action;end
      end

      context 'when there is no user logged in' do
          before do
            allow(app_controller).to receive(:current_user).and_return(nil)

            # Adicionando uma nova rota ficticia
            routes.draw { get 'restricted_action' => 'anonymous#restricted_action' }
            get :restricted_action
          end

        it 'return status code 401' do
          expect(response).to have_http_status(401)
        end

        it 'return the json data for the erros' do
          expect(json_body).to have_key(:errors)
        end
      end

    end
end

# def current_user
#   User.find_by(auth_token: request.header['Authorization'] )
# end

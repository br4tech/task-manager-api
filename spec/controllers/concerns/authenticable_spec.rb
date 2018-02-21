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
end

# def current_user
#   User.find_by(auth_token: request.header['Authorization'] )
# end

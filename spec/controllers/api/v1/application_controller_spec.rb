require 'rails_helper'

RSpec.describe Api::V1::ApplicationController, type: :controller do
  describe 'includes the correct concerts' do
    
    # Retorna uma lista com todas implentações que foram incluidade no ApplicationController
    it{ expect(controller.class.ancestors).to include(Authenticable)}
  end
end

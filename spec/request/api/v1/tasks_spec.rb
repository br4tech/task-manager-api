require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  before { host! 'api.taskmanager.test'}

  let!(:user){ create(:user)}
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      # Cria uma lista com 5 tarefas utilizando o comando do FactoryBot
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}, headers: headers
    end

    it 'return status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'return 5 tasks from database' do
      expect(json_body[:tasks].count).to eq(5)
    end

  end

  describe 'GET /tasks/:id' do
     let(:task){ create(:task, user_id: user.id )}

     before { get "/tasks/#{task.id}", params: {}, headers: headers }

     it 'return status code 200' do
       expect(response).to have_http_status(200)
     end

     it 'return the json for task' do
       expect(json_body[:title]).to eq(task.title)
     end

  end
end

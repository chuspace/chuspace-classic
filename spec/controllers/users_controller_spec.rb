# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST create' do
    it 'renders the new template' do
      VCR.use_cassette 'http://localhost:3001/init_repo' do
        post :create, params: { user: { name: 'Foo', email: 'foo@bar.com', nickname: 'foobar' } }, format: :json
        expect(response.body).to eq({ "success": 'Welcome aboard! we have sent you an email with login link.' }.to_json)
      end
    end
  end
end

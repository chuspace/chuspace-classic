# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  describe 'POST create' do
    it 'creates a person' do
      post :create, params: { person: { name: 'Foo', email: 'foo@bar.com', nickname: 'foobar' } }, format: :json

      expect(json).to eq('success' => 'Welcome aboard! we have sent you an email with login link.')
    end

    it 'returns errors for invalid person' do
      post :create, params: { person: { name: 'Foo', email: 'foo@bar.com', nickname: 'foobar' } }, format: :json
      expect(response.body).to eq({ "success": 'Welcome aboard! we have sent you an email with login link.' }.to_json)

      post :create, params: { person: { name: 'Foo', email: 'foo@bar.com', nickname: 'foobar' } }, format: :json

      expect(json).to have_key('errors')
      expect(json).to be_an_instance_of(Hash)
      expect(json['errors']).to be_an_instance_of(Array)

      expect(json['errors']).to include(include('field' => 'email', 'errors' => 'has already been taken'))
      expect(json['errors']).to include(include('field' => 'nickname', 'errors' => 'has already been taken'))
    end
  end
end

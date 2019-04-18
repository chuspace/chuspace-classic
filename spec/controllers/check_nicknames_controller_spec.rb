# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckNicknamesController, type: :controller do
  describe 'POST create' do
    it 'should return true if nickname is available' do
      post :create, params: { nickname: 'foo' }, format: :json
      expect(JSON.parse(response.body)['available']).to be_truthy
    end

    it 'should return false if nickname is unavailable with errors' do
      create(:user, name: 'John Doe', nickname: 'doe')
      post :create, params: { nickname: 'doe' }, format: :json

      expect(JSON.parse(response.body)['available']).to be_falsy
      expect(JSON.parse(response.body)['errors']).to eq(
                  [
                    {
                      'errors' => 'Oops! doe is already taken.',
                      'field' => 'nickname'
                    }
                  ]
                )
    end

    it 'should return validation errors if bad nickname' do
      post :create, params: { nickname: 'doe--' }, format: :json

      expect(JSON.parse(response.body)['available']).to be_falsy
      expect(JSON.parse(response.body)['errors']).to eq(
                  [
                    {
                      'errors' =>
                        'Nickname may only contain alphanumeric characters or single hyphens, and cannot begin or end with a hyphen',
                      'field' => 'nickname'
                    }
                  ]
                )
    end

    it 'should return validation errors if bad nickname' do
      post :create, params: { nickname: '122*doe' }, format: :json

      expect(JSON.parse(response.body)['available']).to be_falsy
      expect(JSON.parse(response.body)['errors']).to eq(
                  [
                    {
                      'errors' =>
                        'Nickname may only contain alphanumeric characters or single hyphens, and cannot begin or end with a hyphen',
                      'field' => 'nickname'
                    }
                  ]
                )
    end

    it 'should return validation errors if bad nickname' do
      post :create, params: { nickname: '122doe' }, format: :json
      expect(JSON.parse(response.body)['available']).to be_truthy
    end
  end
end

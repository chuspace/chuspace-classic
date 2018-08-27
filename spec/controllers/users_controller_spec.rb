# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST create' do
    it 'renders the new template' do
      post :create
      expect(response).to render_template('new')
    end
  end
end

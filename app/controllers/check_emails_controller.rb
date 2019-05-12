# frozen_string_literal: true

class CheckEmailsController < ApplicationController
  def create
    user = User.new(email: params[:value])

    if user.valid_attributes?(:email)
      head :ok, content_type: 'text/html'
    else
      response.headers['Content-type'] = 'text/html; fragment'
      render html: user.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end
end

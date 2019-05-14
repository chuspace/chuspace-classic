# frozen_string_literal: true

class CheckEmailsController < ApplicationController
  def signup
    @record = User.new(email: params[:email])
    validate!
  end

  def invite
    @record = Invite.new(email: params[:email])
    validate!
  end

  private

  def validate!
    if @record.valid_attributes?(:email)
      head :ok, content_type: 'text/html'
    else
      response.headers['Content-type'] = 'text/html; fragment'
      render html: @record.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end
end

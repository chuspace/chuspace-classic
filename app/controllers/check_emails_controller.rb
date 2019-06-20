# typed: true
# frozen_string_literal: true

class CheckEmailsController < ApplicationController
  def signup
    @record = User.new(email: params[:value])
    validate!
  end

  def invite
    @record = Invite.new(email: params[:value])
    validate!
  end

  private

  def validate!
    if @record.valid_attributes?(:email)
      head :ok
    else
      render html: @record.errors.messages[:email].to_sentence.html_safe, status: :unprocessable_entity
    end
  end
end

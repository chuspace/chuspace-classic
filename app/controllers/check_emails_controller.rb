# typed: ignore
# frozen_string_literal: true

class CheckEmailsController < ApplicationController
  def create
    user = User.new(email: params[:value])

    if user.valid_attributes?(:email)
      head :ok
    else
      render html: user.errors.messages[:email].to_sentence.html_safe, status: :unprocessable_entity
    end
  end
end

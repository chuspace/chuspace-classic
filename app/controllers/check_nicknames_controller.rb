# frozen_string_literal: true

class CheckNicknamesController < ApplicationController
  def create
    user = User.new(nickname: params[:nickname])

    if user.valid_attributes?(:nickname)
      head :ok
    else
      render html: user.errors.messages_for(:nickname).to_sentence.html_safe, status: :unprocessable_entity
    end
  end
end

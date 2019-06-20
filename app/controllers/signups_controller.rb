# typed: true
# frozen_string_literal: true

class SignupsController < ApplicationController
  before_action :redirect_if_registered

  def index
    @invite = Invite.find_by(code: params[:code])

    if @invite.blank?
      redirect_to root_path, notice: t('signups.index.code_invalid')
    elsif @invite.accepted?
      redirect_to signins_path, notice: t('signups.index.code_accepted')
    elsif @invite.may_accept?
      @user = User.new(email: @invite.email)
      render :index
    end
  end

  private

  def redirect_if_registered
    redirect_back(fallback_location: root_path) if Current.user.present?
  end
end

# typed: ignore
# frozen_string_literal: true

class Settings::KeysController < ApplicationController
  before_action :authenticate!
  before_action :find_key, only: :destroy

  def new
    @key = Current.user.keys.build
    authorize! @key
  end

  def index
    @user = Current.user
    authorize!
  end

  def create
    @key = Current.user.keys.build(key_params)
    authorize! @key

    respond_to do |format|
      if @key.save
        format.html { redirect_to settings_keys_path, notice: t('settings.keys.create.success') }
      else
        format.js
        format.html { redirect_to new_settings_keys_path, notice: @key.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    authorize! @key

    if @key.destroy
      redirect_to settings_keys_path, notice: t('settings.keys.destroy.success')
    else
      redirect_to settings_keys_path, notice: @key.api_validation_errors
    end
  end

  private

  def key_params
    params.require(:key).permit(:title, :key)
  end

  def find_key
    @key = Current.user.keys.find(params[:id])
  end
end

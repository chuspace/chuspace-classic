# typed: ignore
# frozen_string_literal: true

class Settings::KeysController < ApplicationController
  before_action :authenticate!
  before_action :find_key, only: %i[update destroy]

  def new
    @key = Current.user.keys.build
  end

  def index
    @user = Current.user
  end

  def create
    @key = Current.user.keys.build(key_params)

    if @key.save
      redirect_to settings_keys_path, notice: t('settings.keys.create.success')
    else
      render :new
    end
  end

  def destroy
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
    @key = Key.find(params[:id])
  end
end

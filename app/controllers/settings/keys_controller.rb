# typed: ignore
# frozen_string_literal: true

class Settings::KeysController < ApplicationController
  before_action :authenticate!
  before_action :find_key, only: %i[update destroy]

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

    if @key.save
      redirect_to settings_keys_path, notice: t('settings.keys.create.success')
    else
      render :new, turblinks: true
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
    @key = Key.find(params[:id])
  end
end

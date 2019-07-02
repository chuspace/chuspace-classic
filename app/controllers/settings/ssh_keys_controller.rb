# typed: ignore
# frozen_string_literal: true

class Settings::SshKeysController < ApplicationController
  before_action :authenticate!
  before_action :find_ssh_key, only: %i[update destroy]

  def new
    @key = Current.user.ssh_keys.build
  end

  def index
    @user = Current.user
  end

  def create
    key = Current.user.ssh_keys.build(key_params)

    if key.save
      redirect_to settings_ssh_keys_path, notice: t('settings.ssh_keys.create.success')
    else
      render json: { errors: key.api_validation_errors }
    end
  end

  def destroy
    if @ssh_key.destroy
      redirect_to settings_ssh_keys_path, notice: t('settings.ssh_keys.destroy.success')
    else
      redirect_to settings_ssh_keys_path, notice: @ssh_key.api_validation_errors
    end
  end

  private

  def key_params
    params.require(:ssh_key).permit(:title, :key)
  end

  def find_ssh_key
    @ssh_key = SshKey.find(params[:id])
  end
end

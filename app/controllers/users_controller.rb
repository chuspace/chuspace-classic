# typed: ignore
# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show
  skip_verify_authorized only: :show

  def show
    @posts = @user.posts.published.includes(:author).limit(20).order(id: :desc)
  end

  def update
    @user = Current.user
    @user.assign_attributes(update_params)
    authorize! @user

    respond_to do |format|
      if @user.save
        format.html { redirect_to settings_profiles_path, notice: 'Profile successfully updated' }
      else
        format.js
        format.html { redirect_to settings_profiles_path, notice: @user.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @user = Current.user
    authorize! @user

    respond_to do |format|
      if @user.destroy
        format.html { redirect_to root_path, notice: 'Successfully deleted your account' }
      else
        format.js { render :update }
        format.html { redirect_to settings_profiles_path, notice: @user.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def update_params
    params.require(:user).permit(:email, :name, :bio, :url, :location, :company, :avatar)
  end

  def find_user
    @user = User.find_by!(nickname: params[:nickname])
  end
end

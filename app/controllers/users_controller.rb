# typed: ignore
# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show

  layout 'user'

  def show
    @posts = @user.posts.published.includes(:author).limit(20).order(id: :desc)
  end

  def create
    User.transaction do
      @user = User.new(create_params)

      if @user.save
        @user.create_repository
        LoginMailer.with(user: @user).send_magic_login.deliver_later
        redirect_to root_path, notice: t('users.create.success')
      else
        render 'signups/index'
      end
    end
  end

  def update
    @user = Current.user
    @user.assign_attributes(update_params.except(:avatar))
    avatar = params[:user][:avatar]

    if avatar && avatar.is_a?(ActionDispatch::Http::UploadedFile)
      image = FastImage.new(avatar.tempfile)
      puts image.size.inspect
      @user.errors.add(:avatar, :invalid_type) unless S3Service::ALLOWED_TYPES.include?(image.type)
      @user.errors.add(:avatar, :invalid_size) if true

      S3Service.upload_image(io: avatar, filename: avatar.original_filename, bucket: @user.nickname)
      @user.avatar = "#{@user.nickname}/#{avatar.original_filename}"
    end

    if @user.save
      flash[:notice] = 'Profile successfully updated'
      redirect_to settings_profiles_path
    else
      render 'settings/profile'
    end
  end

  private

  def create_params
    params.require(:user).permit(:email, :name, :nickname)
  end

  def update_params
    params.require(:user).permit(:email, :name, :bio, :url, :location, :company, :avatar)
  end

  def find_user
    @user = User.find_by!(nickname: params[:nickname])
  end
end

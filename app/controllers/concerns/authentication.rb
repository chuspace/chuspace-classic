# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included { before_action :authenticate }

  def login(user)
    cookies.encrypted[:user_id] = { value: user.id, expires: 1.year.from_now }
    user.update_tracked_fields!(request)
    user.regenerate_auth_token
    user
  end

  def logout
    cookies.encrypted[:user_id] = nil
  end

  private

  def authenticate
    authenticated_user = User.find_by(id: cookies.encrypted[:user_id])
    logout if authenticated_user.blank?
    Current.user = authenticated_user
  end

  def authenticate!
    redirect_to root_url unless authenticate
  end
end

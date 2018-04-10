# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def login(user)
    cookies.encrypted[:user_id] = { value: user.id, expiry: 1.year.from_now }
  end

  def logout
    cookies.encrypted[:user_id] = nil
  end

  private
    def authenticate
      authenticated_user = User.find_by(id: cookies.encrypted[:user_id])
      Current.user = authenticated_user
    end

    def authenticate!
      redirect_to root_url unless authenticate
    end
end

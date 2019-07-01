# typed: false
# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
      Current.user = current_user

      logger.add_tags current_user.name
    end

    def disconnect
      Current.user = nil
      self.current_user = nil
    end

    private

    def find_current_user
      User.find_by(id: cookies.encrypted[:user_id]) || reject_unauthorized_connection
    end
  end
end

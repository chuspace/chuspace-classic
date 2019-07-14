# typed: ignore
# frozen_string_literal: true

class PrivateRootConstraint
  def matches?(request)
    User.find_by(id: request.cookie_jar.encrypted[:user_id])&.present?
  rescue NoMethodError
    false
  end
end

# typed: ignore
# frozen_string_literal: true

class SignupConstraint
  def matches?(request)
    Invite.find_by(code: request.params[:code])
  end
end

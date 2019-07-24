# typed: true
# frozen_string_literal: true

class MobiusConstraint
  def matches?(request)
    request.params[:token] == ENV['MOBIUS_TOKEN']
  end
end

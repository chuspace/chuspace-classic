# frozen_string_literal: true

module JsonHelper
  def json
    JSON.parse(response.body)
  end
end

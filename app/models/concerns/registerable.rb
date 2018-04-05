# frozen_string_literal: true

module Registerable
  extend ActiveSupport::Concern

  class_methods do
    def register_from_email(params)
      create(params)
    end

    def register_from_github(params)
      create(params)
    end
  end
end

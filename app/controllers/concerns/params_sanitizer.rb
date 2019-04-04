# frozen_string_literal: true

module ParamsSanitizer
  extend ActiveSupport::Concern

  included do
    before_action :sanitize_params!
  end

  private

  def sanitize_params!
    strip_whitespace!(params)
  end

  def strip_whitespace!(params_to_strip)
    params_to_strip.each do |_, v|
      if v.respond_to? :strip!
        v.strip!
      elsif v.respond_to? :each_pair
        strip_whitespace!(v)
      end
    end
  end
end

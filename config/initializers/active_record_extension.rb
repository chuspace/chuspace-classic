# frozen_string_literal: true

module ActiveRecordExtension
  extend ActiveSupport::Concern

  def graphql_validation_errors
    errors.messages.map do |field, errors|
      OpenStruct.new(field: field.to_s, messages: errors)
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)

# frozen_string_literal: true

module ActiveRecordExtension
  extend ActiveSupport::Concern

  def graphql_validation_errors
    OpenStruct.new(field: field.to_s, messages: errors)
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)

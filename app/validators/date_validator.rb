# typed: ignore
# frozen_string_literal: true

class DateValidator < ActiveModel::EachValidator
  CHECKS = { after: :>, after_or_equal_to: :>=, before: :<, before_or_equal_to: :<=, equal_to: :== }.freeze

  def initialize(options)
    super(options.reverse_merge(allow_nil: false))
  end

  def check_validity!
    keys = CHECKS.keys
    options.slice(*keys).each do |option, value|
      if is_time?(value) || value.is_a?(Proc) || value.is_a?(Symbol) ||
         (defined?(ActiveSupport::TimeWithZone) && value.is_a?(ActiveSupport::TimeWithZone))
        next
      end
      raise ArgumentError, ":#{option} must be a time, a date, a time_with_zone, a symbol or a proc"
    end
  end

  def validate(record)
    attributes.each do |attribute|
      value = record.read_attribute_for_validation(attribute)
      validate_each(record, attribute, value)
    end
  end

  def validate_each(record, attr_name, value)
    before_type_cast = :"#{attr_name}_before_type_cast"

    value_before_type_cast = record.respond_to?(before_type_cast) ? record.send(before_type_cast) : nil

    if value_before_type_cast.present? && value.nil?
      record.errors.add(attr_name, :not_a_date, options)
      return
    end

    return if (value.nil? && options[:allow_nil]) || (value.blank? && options[:allow_blank])

    unless value
      record.errors.add(attr_name, :not_a_date, options)
      return
    end

    unless is_time?(value)
      record.errors.add(attr_name, :not_a_date, options)
      return
    end

    options.slice(*CHECKS.keys).each do |option, option_value|
      option_value = option_value.call(record) if option_value.is_a?(Proc)
      option_value = record.send(option_value) if option_value.is_a?(Symbol)

      original_value = value
      original_option_value = option_value

      # To enable to_i conversion, these types must be converted to Datetimes

      if defined?(ActiveSupport::TimeWithZone)
        option_value = option_value.to_datetime if option_value.is_a?(ActiveSupport::TimeWithZone)
        value = value.to_datetime if value.is_a?(ActiveSupport::TimeWithZone)
      end

      if defined?(Date)
        option_value = option_value.to_datetime if option_value.is_a?(Date)
        value = value.to_datetime if value.is_a?(Date)
      end

      unless is_time?(option_value) && value.to_i.send(CHECKS[option], option_value.to_i)
        record.errors.add(
          attr_name,
          :"date_#{option}",
          options.merge(
            value: original_value,
            date:
              (
                begin
                  I18n.localize(original_option_value)
                rescue StandardError
                  original_option_value
                end
              )
          )
        )
      end
    end
  end

  private

  def is_time?(object)
    object.is_a?(Time) || (defined?(Date) && object.is_a?(Date)) ||
      (defined?(ActiveSupport::TimeWithZone) && object.is_a?(ActiveSupport::TimeWithZone))
  end
end

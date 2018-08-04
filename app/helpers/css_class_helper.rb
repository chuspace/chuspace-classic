# frozen_string_literal: true

module CssClassHelper
  def class_for(tag, options = { type: nil, additional: '' })
    type = options[:type]&.to_sym
    additional = options[:additional]

    default_classes = get_tag_type(tag).fetch(:default)

    if type.present?
      type_classes = get_tag_type(tag).fetch(type)
      "#{default_classes} #{type_classes} #{additional}"
    else
      "#{default_classes} #{additional}"
    end
  end

  private
    def get_tag_type(tag)
      send("#{tag}_css_classes")
    end
end

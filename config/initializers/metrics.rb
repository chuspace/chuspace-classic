# frozen_string_literal: true

Yabeda.configure do
  group :git do
    histogram :runtime do
      buckets [0.1, 10, 100]
      comment 'How long does a command took?'
      unit :seconds
    end
  end
end

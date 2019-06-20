# typed: true
class BadgeComponent < Components::Component
  STYLES = %w[primary grey]

  attribute :style, default: :grey
end

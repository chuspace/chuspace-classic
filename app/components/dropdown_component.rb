# typed: ignore
# frozen_string_literal: true

class DropdownComponent < Components::Component
  element :opener
  attribute :items
  attribute :drop_arrow, default: :yes

  def arrow?
    drop_arrow == :yes
  end
end

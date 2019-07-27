# typed: ignore
# frozen_string_literal: true

class ImageConstraint
  def matches?(request)
    MiniMime.lookup_by_filename(request.path)&.content_type&.include?('image')
  end
end

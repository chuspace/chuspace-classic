# frozen_string_literal: true

class MarkdownRenderer < Redcarpet::Render::HTML
  def preprocess(text)
    %(<blockquote class="my-custom-class">#{quote}</blockquote>)
  end
end

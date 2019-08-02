# typed: false
# frozen_string_literal: true

module EditionHelper
  def edition_header(post, edition)
    render partial: "posts/editions/header/#{params[:action]}", locals: { post: post, edition: edition }
  end
end

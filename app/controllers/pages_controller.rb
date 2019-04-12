# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    PostRepository.new.search(query: { term: { status: 'published' } }).first(20)
  end
end

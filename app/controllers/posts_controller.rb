# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: [:new, :create]
  layout 'editor', only: :new
end

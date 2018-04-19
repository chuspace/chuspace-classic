# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!
  layout 'editor', only: :new

  def new
  end

  def index
  end

  def show
  end
end

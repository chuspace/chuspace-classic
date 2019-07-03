# frozen_string_literal: true

class PublishController < ApplicationController
  before_action :find_post

  def index
    @post = Post.find_by(params[:slug])
  end

  def create
    @post = Post.find_by(params[:slug])
  end

  private

  def find_post
    @post = Post.find_by(params[:slug])
  end
end

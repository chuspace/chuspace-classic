# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: [:new, :create]
  layout 'editor', only: :new

  def create
    Posts::Create.call(author: author, params: params)
  end

  def update
    Posts::Update.call(author: author, params: params, committer: Current.person)
  end

  def destroy
    Posts::Destroy.call(params[:id])
  end

  private

  def author
    @author = Person.find_by_nickname(params[:author])
  end
end

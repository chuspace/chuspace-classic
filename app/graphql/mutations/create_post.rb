# frozen_string_literal: true

class Mutations::CreatePost < ApplicationMutation
  field :post, Types::PostType, null: true

  argument :body, String, required: true
  argument :commit, String, required: true
  argument :title, String, required: true

  def resolve(**inputs)
    post = Current.user.posts.create(
      body: params[:markdown],
      repo: Current.user.repo,
      commit: 'Add another example',
      title: params[:title]
    )

    { post: post }
  end
end

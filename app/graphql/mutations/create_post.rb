# frozen_string_literal: true

class Mutations::CreatePost < ApplicationMutation
  field :post, Types::PostType, 'New post', null: true

  argument :title, String, 'The title of the post', required: true
  argument :body, String, 'The body of the post', required: true
  argument :commit, String, 'The commit message', required: true

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

# frozen_string_literal: true

class Mutations::CreatePostMutation < ApplicationMutation
  field :post, Types::PostType, 'New post', null: true

  argument :title, String, 'The title of the post', required: true
  argument :body, String, 'The body of the post', required: true
  argument :commit, String, 'The commit message', required: true

  def resolve(**inputs)
    post = Current.user.posts.build(
      body: inputs[:markdown],
      repo: Current.user.repo,
      commit: 'Add another example',
      title: inputs[:title]
    )

    if post.save
      { post: post }
    else
      { post: nil, errors: post.graphql_validation_errors }
    end
  end
end

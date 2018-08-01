class Mutations::Posts::Create < GraphQL::Schema::RelayClassicMutation
  return_field :post, Types::PostType

  input_field :body, !types.String
  input_field :commit, !types.String
  input_field :title, !types.String

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

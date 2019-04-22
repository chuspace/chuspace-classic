# frozen_string_literal: true

module Posts
  class Create
    include Service

    attr_reader :author, :params

    def call(author:, params:)
      @author = author
      @params = ActionController::Parameters.new(params)

      post = Post.new(post_params)
      post.author_nickname = author.nickname

      blob =
        Git::Commit.create(
          repository: author.blog,
          author: author,
          options: {
            commit: { message: params[:commit_message] || "Created post #{post.filename}" },
            file: { content: post.raw_content, path: post.filename }
          }
        )

      Post.initialize_from_blob(blob)
    end

    private

    def post_params
      params.permit(:title, :excerpt, :filename, :status, :tags, :slug, :content, :tags, :published_at)
    end
  end
end

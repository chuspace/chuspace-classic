# frozen_string_literal: true

module Posts
  class Create
    include Service

    attr_reader :blog, :params

    def call(blog:, params:)
      @blog = blog
      @params = params

      post = Post.new(post_params)
      post.blog = blog
      post.author = blog.author

      if post.save
        blob =
          Git::Commit.create(
            repository: blog.repo,
            author: author,
            options: {
              commit: { message: params[:commit_message] || "Created post #{post.filename}" },
              file: { content: post.blob_content, path: post.filename }
            }
          )
      end
    end

    private

    def post_params
      params.permit(:title, :excerpt, :filename, :status, :tags, :slug, :body, :tags, :published_at)
    end
  end
end

# frozen_string_literal: true

module Posts
  class Create
    include Service

    attr_reader :blog, :user, :params

    def call(blog:, user:, params:)
      @blog = blog
      @user = user
      @params = params

      post = blog.posts.build(post_params)
      post.author = user

      if post.valid?
        filename = "#{post.slug}.md"

        blob =
          Git::Commit.create(
            repository: blog.repo,
            author: blog.author,
            committer: user,
            options: {
              commit: { message: params[:commit_message] || "Created post #{filename}" },
              file: { content: post.blob_content, path: filename }
            }
          )

        post.blob_id = blob.id
      end

      post
    end

    private

    def post_params
      params.permit(:title, :excerpt, :filename, :status, :tags, :slug, :body, :tags, :published_at)
    end
  end
end

# frozen_string_literal: true

module Posts
  class Update
    include Service

    attr_reader :author, :rugged, :params

    def call(author:, params:, committer: nil)
      @author = author
      @params = ActionController::Parameters.new(params)

      post = author.blog.find_blob(params[:id])
      post.assign_attributes(post_params)

      if post.valid?
        blob = Git::Commit.create(
          repository: author.blog,
          author: author,
          committer: committer,
          action: post.filename_was.blank? ? :update : :rename,
          options: {
            commit: {
              message: params[:commit_message] || "Updated post #{post.filename}"
            },
            file: {
              content: post.raw_content,
              path: post.filename,
              previous_path: post.filename_was
            }
          }
        )

        Post.initialize_from_blob(blob)
      else
        post.errors
      end
    end

    private

    def post_params
      params.permit(:title, :excerpt, :filename, :status, :tags, :slug, :content, :tags, :published_at)
    end
  end
end

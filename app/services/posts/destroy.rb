# frozen_string_literal: true

module Posts
  class Destroy
    include Service

    def call(author:, id:)
      post = author.blog.find_blob(id)

      Git::Commit.create(
        repository: author.blog,
        author: author,
        action: :remove,
        options: {
          commit: { message: "Deleted #{post.filename}" },
          file: { path: post.filename }
        }
      )
    end
  end
end

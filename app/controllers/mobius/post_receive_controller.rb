# typed: ignore
# frozen_string_literal: true

module Mobius
  class PostReceiveController < BaseController
    def create
      old_commit_sha = params[:old_commit_sha]
      new_commit_sha = params[:new_commit_sha]
      ref = params[:ref]

      author = User.find_by(id: params[:author_id])
      publication = author.publications.find_by(id: params[:publication_id], owner: author)
      repository = publication&.repository

      unless repository
        Rails.logger.error("Repository not found: author-#{author.id} repository-#{repository.id}")
        return
      end

      author.transaction do
        old_commit = repository.lookup(old_commit_sha)
        new_commit = repository.lookup(new_commit_sha)
        diff = old_commit.diff(new_commit).find_similar!(renames: true)

        diff.deltas.each do |delta|
          git_blob = repository.blob_at(path: delta.new_file[:path])
          next unless git_blob&.post?

          case delta.status
          when :added, :modified
            markdown = PostMarkdownService.call(content: git_blob.content)
            slug = markdown.title&.to_slug&.to_ascii&.normalize&.to_s || git_blob.oid[0..8]
            post = author.posts.find_or_initialize_by(blob_path: git_blob.path, publication: publication)
            post.assign_attributes(slug: slug) if post.new_record?
            post.save!
          when :renamed
            author.posts.find_by(blob_path: delta.old_file[:path])&.update!(blob_path: delta.new_file[:path])
          when :deleted
            author.posts.find_by(blob_path: delta.old_file[:path])&.destroy!
          end
        end
      end

      Rails.logger.error("Posts synced: author-#{author.id} publication-#{publication.id}")
      self.status = 200
    end
  end
end

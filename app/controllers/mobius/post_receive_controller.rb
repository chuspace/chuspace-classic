# typed: ignore
# frozen_string_literal: true

module Mobius
  class PostReceiveController < BaseController
    class MobiusUnauthorisedError < StandardError; end

    def create
      old_commit_sha = params[:old_commit_sha]
      new_commit_sha = params[:new_commit_sha]
      ref = params[:ref]

      author = User.find_by(id: params[:author_id])
      publication = Publication.find_by(id: params[:publication_id])
      repository = publication&.repository

      unless publication.members.include?(author)
        Rails.logger.error("You are not allowed to update: publication-#{publication.id} repository-#{repository.id}")
        return
      end

      unless repository
        Rails.logger.error("Repository not found: publication-#{publication.id} repository-#{repository.id}")
        return
      end

      Post.transaction do
        old_commit = repository.lookup(old_commit_sha)
        new_commit = repository.lookup(new_commit_sha)
        diff = old_commit.diff(new_commit).find_similar!(renames: true)

        diff.deltas.each do |delta|
          git_blob = repository.blob_at(path: delta.new_file[:path])
          next unless git_blob&.post?

          case delta.status
          when :added, :modified
            slug = git_blob.name || git_blob.oid[0..8]
            post = publication.posts.find_or_initialize_by(blob_path: git_blob.path, author: author)
            post.assign_attributes(slug: slug) if post.new_record?
            post.save!
          when :renamed
            publication.posts.find_by(blob_path: delta.old_file[:path])&.update!(blob_path: delta.new_file[:path])
          when :deleted
            publication.posts.find_by(blob_path: delta.old_file[:path])&.destroy!
          end
        end
      end

      Rails.logger.error("Posts synced: author-#{author.id} publication-#{publication.id}")
      self.status = 200
    end
  end
end

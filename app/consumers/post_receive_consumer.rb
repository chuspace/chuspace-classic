# typed: false
# frozen_string_literal: true

class PostReceiveConsumer < Racecar::Consumer
  subscribes_to 'repositories'

  attr_reader :repository, :author, :old_commit_sha, :new_commit_sha, :ref

  def process(message)
    @author = User.find_by(id: author_id)
    @old_commit_sha = old_commit_sha
    @new_commit_sha = new_commit_sha
    @ref = ref
    @repository = Repository.find_by(id: repository_id, author: author)

    unless repository
      Rails.logger.error("Repository not found: author-#{author.id} repository-#{repository.id}")
      return
    end

    author.transaction do
      old_commit = repository.lookup(old_commit_sha)
      new_commit = repository.lookup(new_commit_sha)

      diff = old_commit.diff(new_commit).find_similar!(renames: true)
      blobs ||= Git::Blob.all(repository, new_commit_sha)

      diff.deltas.each do |delta|
        next unless File.extname(delta.new_file[:path] || delta.old_file[:path]).end_with?('.md')
        git_blob = blobs.find { |blob| blob.id == delta.new_file[:oid] }

        case delta.status
        when :added, :modified
          post = author.posts.find_or_initialize_by(blob_path: git_blob.path)
          markdown = PostMarkdownService.call(content: git_blob.content)
          post.assign_attributes(slug: markdown.slug) if post.new_record?
          post.save
        when :renamed
          author.posts.find_by(blob_path: delta.old_file[:path])&.update(blob_path: delta.new_file[:path])
        when :deleted
          author.posts.find_by(blob_path: delta.old_file[:path])&.destroy
        end
      end
    end
  end
end

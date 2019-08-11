# typed: false
# frozen_string_literal: true

class PostReceiveConsumer < Racecar::Consumer
  subscribes_to 'repositories'
  attr_reader :repository, :author, :old_commit_sha, :new_commit_sha, :ref

  def process(message)
    payload = JSON.parse(message.value)
    @old_commit_sha = payload['old_commit_sha']
    @new_commit_sha = payload['new_commit_sha']
    @ref = payload['ref']
    @author = User.find_by(id: payload['author_id'])
    @repository = Repository.find_by(id: payload['repository_id'], author: author)

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
        next unless git_blob&.post? || git_blob&.image?

        case delta.status
        when :added, :modified
          add_or_update_blob(git_blob: git_blob)
        when :renamed
          renamed_blob(git_blob: git_blob, old_path: delta.old_file[:path])
        when :deleted
          delete_blob(path: delta.old_file[:path])
        end
      end
    end

    Rails.logger.error("Posts synced: author-#{author.id} repository-#{repository.id}")
  end

  private

  def add_or_update_blob(git_blob:)
    if git_blob.image?
      image = repository.images.find_or_initialize_by(name: git_blob.name, blob_path: git_blob.path)
      image.assign_attributes(image: git_blob.io) if image.new_record?
      image.save!
    elsif git_blob.post?
      post = author.posts.find_or_initialize_by(blob_path: git_blob.path, repository: repository)
      post.assign_attributes(slug: git_blob.oid[0..8]) if post.new_record?
      post.save!
    end
  end

  def renamed_blob(git_blob:, old_path:)
    old_image = repository.images.find_by(blob_path: old_path)
    return add_or_update_blob(git_blob: git_blob) if old_image.blank?

    if git_blob.image?
      old_image&.update!(name: git_blob.name, blob_path: git_blob.path)
    elsif git_blob.post?
      old_image&.update!(blob_path: git_blob.path)
    end
  end

  def delete_blob(path:)
    if git_blob.image?
      repository.images.find_by(blob_path: path)&.destroy!
    elsif git_blob.post?
      author.posts.find_by(blob_path: path)&.destroy!
    end
  end
end

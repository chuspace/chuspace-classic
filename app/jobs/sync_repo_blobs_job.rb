# frozen_string_literal: true

class SyncRepoBlobsJob < ApplicationJob
  queue_as :default

  def perform(id)
    repository = Repository.find(id)
    blobs = Git::Blob.all(repository, repository.commit_sha)

    blobs.each do |git_blob|
      blob = repository.blobs.find_or_initialize_by(path: git_blob.path)
      attrs = { name: git_blob.name, blob: git_blob.content, binary: git_blob.binary }.freeze

      if blob
        blob.update(attrs)
      else
        repository.blobs.create(path: git_blob.path, **attrs)
      end
    end

    repository.blobs.reload.where.not(path: blobs.map(&:path)).delete_all
  end
end

# frozen_string_literal: true

module Blobable
  extend ActiveSupport::Concern

  included do
    FRONTMATTER_ATTRS = %w[title slug parent_slug excerpt topics status published_at]
    BLOB_ATTRS = FRONTMATTER_ATTRS + %w[body]
  end

  class_methods do
    def find_or_initialize_from_blob(author:, repository:, blob:, blob_name:)
      post = Post.find_or_initialize_by(author: author, repository: repository, blob_name: blob_name)
      attrs = YAML.safe_load(blob)

      fail Post::InvalidFrontMatterError unless attrs.is_a?(Hash)
      attrs = attrs&.deep_symbolize_keys!
      post.assign_attributes(attrs)
      post.body = blob.gsub(/---(.|\n)*---/, '').strip!
      post

    rescue TypeError, ArgumentError, Psych::SyntaxError, Post::InvalidFrontMatterError
      post
    end

    def sync_from_repo(author:, repository:, commit_sha:)
      Post.transaction do
        old_rugged_commit = repository.commit
        new_rugged_commit = repository.lookup(commit_sha)
        diff = old_rugged_commit.diff(new_rugged_commit)

        diff.deltas.each do |delta|
          next unless delta.new_file[:path].ends_with?('.md')

          blob = repository.find_blob(delta.new_file[:oid])
          content = blob&.content
          old_name = delta.old_file[:path]
          new_name = delta.new_file[:path]

          case delta.status
          when :added
            post = find_or_initialize_from_blob(author: author, repository: repository, blob: content, blob_name: new_name)
            post.save
          when :renamed, :modified
            post = find_or_initialize_from_blob(author: author, repository: repository, blob: content, blob_name: old_name)
            post.blob_name = delta.new_file[:path]
            post.save
          when :deleted
            post = find_or_initialize_from_blob(author: author, repository: repository, blob: content, blob_name: old_name)
            post.destroy
          end
        end

        repository.update(commit_sha: commit_sha)
      end
    end
  end

  def frontmatter_hash
    FRONTMATTER_ATTRS.each_with_object({}) { |attribute, hash| hash[attribute] = send(attribute) }
  end

  def frontmatter_yaml
    "---\n" + frontmatter_hash.map { |(key, value)| "#{key}: #{value}" }.join("\n") + "\n---"
  end

  def blob_content
    frontmatter_yaml + "\n" + body
  end

  def blob_changed?
    BLOB_ATTRS.any? { |attr| self.send("#{attr}_changed?") }
  end
end

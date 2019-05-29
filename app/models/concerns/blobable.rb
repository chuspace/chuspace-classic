# frozen_string_literal: true

module Blobable
  extend ActiveSupport::Concern

  included do
    FRONTMATTER_ATTRS = %w[title slug parent_slug excerpt tag_slugs status published_at]
    BLOB_ATTRS = FRONTMATTER_ATTRS + %w[body]
  end

  class_methods do
    def sync_from_repo(old_sha:, new_sha:, ref:, user_id:)
      author = User.find(user_id)
      rugged_commit = author.repository.lookup(new_sha)
      diff = Git::Commit.diff_from_parent(rugged_commit)

      diff.deltas.each do |delta|
        next unless delta.new_file[:name].ends_with?('.md')
        old_blob = author.repository.blob_at(old_sha, delta.old_file[:name])
        new_blob = author.repository.blob_at(new_sha, delta.new_file[:name])

        case delta.status
        when :added
          post = find_or_initialize_by(author: author, blob_name: new_blob.name)
          post.sync_from_blob(blob: new_blob)
        when :renamed, :modified
          post = find_by(author: author, blob_name: old_blob.name)
          post.sync_from_blob(blob: new_blob)
        when :deleted
          post = find_by(author: author, blob_name: old_blob.name)
          post.destroy
        end
      end
    end

    def valid_blob?(author:, blob_name:)
      find_or_initialize_from_blob(author: author, blob_name: blob_name).valid?
    end
  end

  def sync_from_blob(blob:)
    return nil unless blob
    attrs = YAML.safe_load(blob.content)
    fail Post::InvalidFrontMatterError unless attrs.is_a?(Hash)

    attrs = attrs&.deep_symbolize_keys!
    self.assign_attributes(attrs)
    self.blob_name = blob.name
    self.body = blob.content.gsub(/---(.|\n)*---/, '').strip!
    self.save
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

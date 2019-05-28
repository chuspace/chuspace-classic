# frozen_string_literal: true

module Blobable
  extend ActiveSupport::Concern

  included do
    FRONTMATTER_ATTRS = %w[title slug parent_slug excerpt tag_slugs status published_at]
    BLOB_ATTRS = FRONTMATTER_ATTRS + %w[body]
    before_validation :assign_blob_id
  end

  def assign_blob_id
    self.blob_id = Rugged::Repository.hash_data(blob_content, :blob)
  end

  class_methods do
    def find_or_initialize_from_blob(author:, blob_id:)
      blob = repo.find_blob(blob_id)
      attrs = YAML.safe_load(blob)
      fail Post::InvalidFrontMatterError unless attrs.is_a?(Hash)

      attrs = attrs&.deep_symbolize_keys!
      body = blob.gsub(/---(.|\n)*---/, '').strip!
      post = find_or_initialize_by(author: author, slug: attrs[:slug])
      post.assign_attributes(attrs)
      post

    rescue ActiveModel::UnknownAttributeError, Post::InvalidFrontMatterError
      false
    end

    def create_from_blob(author:, blob_id:)
      post = find_or_initialize_from_blob(author: author, blob_id: blob_id)
      post.blob_id = blob_id
      post.save
    end

    def update_from_blob(author:, old_blob_id:, new_blob_id:)
      post = find_or_initialize_from_blob(author: author, blob_id: old_blob_id)
      post.blob_id = new_blob_id
      post.save
    end

    def destroy_from_blob(author:, blob_id:)
      post = find_by(author: author, blob_id: blob_id)
      post.destroy
    end

    def valid_blob?(author:, blob_id:)
      find_or_initialize_from_blob(author: author, blob_id: blob_id).valid?
    end
  end

  def blob
    author&.repo&.find_blob(blob_id)
  end

  def blob_name
    "#{slug}.md"
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

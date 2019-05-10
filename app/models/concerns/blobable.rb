# frozen_string_literal: true

module Blobable
  extend ActiveSupport::Concern

  included do
    FRONTMATTER_ATTRS = %w[title slug parent_slug blog_slug excerpt tag_slugs status published_at]
    BLOB_ATTRS = FRONTMATTER_ATTRS + %w[body]
  end

  class_methods do
    def find_or_initialize_from_blob(author:, blob:)
      attrs = YAML.load(blob).deep_symbolize_keys!
      body = blob.gsub(/---(.|\n)*---/, '').strip!

      post = find_or_initialize_by(author: author, slug: attrs[:slug])
      post.assign_attributes(attrs)
      post
    end

    def create_and_commit_from_blob(author:, blob:)
      post = find_or_initialize_from_blob(author: author, blob: blob)
      post.commit_and_save
    end

    def valid_blob?(author:, blob:)
      find_or_initialize_from_blob(author: author, blob: blob).valid?
    end
  end

  def blob
    blog&.repo&.find_blob(blob_id)
  end

  def blob_name
    "#{slug}.md"
  end

  def frontmatter
    "---\n" + FRONTMATTER_ATTRS.map { |attribute| "#{attribute}: #{send(attribute)}" }.join("\n") + "\n---"
  end

  def blob_content
    frontmatter + "\n" + body
  end

  def blob_changed?
    BLOB_ATTRS.any? { |attr| self.send("#{attr}_changed?") }
  end
end

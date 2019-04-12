# frozen_string_literal: true

class PostRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  index_name 'posts'
  document_type 'post'
  klass Post

  settings number_of_shards: 1 do
    mapping do
      indexes :id, type: :keyword
      indexes :slug, type: :keyword
      indexes :title
      indexes :excerpt
      indexes :content
      indexes :tags, type: :keyword
      indexes :status, type: :keyword
      indexes :published_at, type: :date
      indexes :author_email, type: :keyword
      indexes :contributors_email, type: :keyword
    end
  end

  def serialize(document)
    super
  end

  def deserialize(document)
    Post.new ActiveSupport::HashWithIndifferentAccess.new(document['_source']).deep_symbolize_keys
  end
end

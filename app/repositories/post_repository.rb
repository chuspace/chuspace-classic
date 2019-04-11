class PostRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  index_name 'posts'
  document_type 'post'
  klass Post

  settings number_of_shards: 1 do
    mapping do
      indexes :title, analyzer: 'english'
      indexes :excerpt, analyzer: 'english'
      indexes :content, analyzer: 'english'
      indexes :tags, analyzer: 'english', type: :array
      indexes :status, analyzer: 'english'
      indexes :published_at, type: :long
      indexes :author_nickname, analyzer: 'english'
    end
  end

  def serialize(document)
    super
  end

  def deserialize(document)
    Post.new ActiveSupport::HashWithIndifferentAccess.new(document['_source']).deep_symbolize_keys
  end
end

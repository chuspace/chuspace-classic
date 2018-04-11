# frozen_string_literal: true

module GraphqlQueryCache
  def graphql_document(query_string)
    cache_key = Base64.encode64(query_string)
    Rails.cache.fetch(cache_key) do
      GraphQL.parse(query_string)
    end
  end
end

# frozen_string_literal: true

ENV['ELASTICSEARCH_URL'] ||= 'http://localhost:9200'

Elasticsearch::Model.client = Elasticsearch::Client.new({
  log: true
})

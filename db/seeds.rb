# typed: ignore
# frozen_string_literal: true

return unless Rails.env.development? || ENV.fetch('RUN_DB_SEED', 'no') == 'yes'

fetched = 0
total_count = nil

client = Octokit::Client.new(access_token: '84d476ccf244aff5f5bd5f51f006952785f9f883')
queries = [
  'web framework',
  'ruby',
  'javascript',
  'go',
  'python',
  'c',
  'c++',
  'rust'
]

queries.each do |query|
  page = 1
  fetched = 0
  requests = 0

  loop do
    sleep 10 if requests > 0 && requests % 5 == 0

    puts 'making query ' + query.to_s + page.to_s
    client.send(
      :search,
      'search/topics',
      query,
      page: page, per_page: 100, accept: 'application/vnd.github.mercy-preview+json'
    )
    response = client.last_response
    rels = response.rels
    items = response.data.items
    total_count = response.data.total_count
    fetched += 100
    page += 1
    requests += 1

    records = items.map { |item| { name: item.name, created_at: Time.now, updated_at: Time.now } }
    Topic.insert_all(records) if records.any?

    break if total_count < fetched
  rescue Octokit::UnprocessableEntity, Octokit::TooManyRequests
    break
  end
end

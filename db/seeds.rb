# typed: false
# frozen_string_literal: true

return unless Rails.env.development?

fetched = 0
total_count = nil
page = 1
requests = 0

client = Octokit::Client.new(access_token: '84d476ccf244aff5f5bd5f51f006952785f9f883')
queries = [
  'web framework',
  'mobile framework',
  'database',
  'programming language',
  'devops',
  'server',
  'ruby',
  'javascript',
  'go',
  'python'
]

queries.each do |query|
  loop do
    sleep 60 if requests > 0 && requests % 30 == 0

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

    break if total_count <= fetched
  rescue Octokit::UnprocessableEntity
    next
  end
end

# ActiveRecord::Base.transaction do
#   10.times do
#     u = User.create(
#       name: Faker::Name.unique.name,
#       nickname: Faker::Internet.unique.username(8, %w[-]),
#       email: Faker::Internet.unique.email
#     )

#     repo = u.create_repository

#     10.times do
#       sentence = Faker::Lorem.unique.sentence
#       slug = Faker::Internet.slug(sentence, '-')

#       post = Post.new(
#         title: sentence,
#         slug: slug,
#         author: u,
#         repository: repo,
#         blob_name: slug + '.md',
#         excerpt: Faker::Lorem.paragraph(100),
#         body: Faker::Lorem.paragraphs(100).join("\n"),
#         topics: Faker::Lorem.words(4),
#         status: %w[published draft archived].sample,
#         published_at: Time.now
#       )

#       post.repo.commit_sha = post.commit(committer: u)
#       post.save
#     end
#   end
# end

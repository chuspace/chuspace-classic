# frozen_string_literal: true

return unless Rails.env.development?

ActiveRecord::Base.transaction do
  10.times do
    u = User.create(
      name: Faker::Name.unique.name,
      nickname: Faker::Internet.unique.username(8, %w[-]),
      email: Faker::Internet.unique.email
    )

    repo = u.create_repository

    10.times do
      sentence = Faker::Lorem.unique.sentence
      slug = Faker::Internet.slug(sentence, '-')

      post = Post.new(
        title: sentence,
        slug: slug,
        author: u,
        repository: repo,
        blob_name: slug + '.md',
        excerpt: Faker::Lorem.paragraph(100),
        body: Faker::Lorem.paragraphs(100).join("\n"),
        topics: Faker::Lorem.words(4),
        status: %w[published draft archived].sample,
        published_at: Time.now
      )

      post.repo.commit_sha = post.commit(committer: u)
      post.save
    end
  end
end

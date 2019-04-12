
return unless Rails.env.development?

ActiveRecord::Base.transaction do
  1000.times do
    p = Person.create(
      name: Faker::Name.unique.name,
      nickname: Faker::Internet.unique.username(8, %w(-)),
      email: Faker::Internet.unique.email
    )

    100.times do
      sentence = Faker::Lorem.unique.sentence
      slug     = Faker::Internet.slug(sentence, '-')

      post = Post.new(
        title: sentence,
        slug: slug,
        author: p,
        filename: slug + '.md',
        excerpt: Faker::Lorem.paragraph(100),
        content: Faker::Lorem.paragraphs(100).join("\n"),
        tags: Faker::Lorem.words(4),
        status: %w(published draft archieved).sample,
        published_at: Time.now,
      )

      post.add
    end
  end
end


return unless Rails.env.development?

ActiveRecord::Base.transaction do
  10.times do
    p = Person.create(
      name: Faker::Name.unique.name,
      nickname: Faker::Internet.unique.username(8, %w(-)),
      email: Faker::Internet.unique.email
    )

    10.times do
      sentence = Faker::Lorem.unique.sentence
      slug     = Faker::Internet.slug(sentence, '-')

      Posts::Create.call(
        author: p,
        params: {
          title: sentence,
          slug: slug,
          author_nickname: p.nickname,
          filename: slug + '.md',
          excerpt: Faker::Lorem.paragraph(100),
          content: Faker::Lorem.paragraphs(100).join("\n"),
          tags: Faker::Lorem.words(4),
          status: %w(published draft archieved).sample,
          published_at: Time.now
        }
      )
    end
  end
end

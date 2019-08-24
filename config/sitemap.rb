# frozen_string_literal: true

# typed: ignore

require 'aws-sdk-s3'

SitemapGenerator::Sitemap.default_host = ENV.fetch('CHUSPACE_URL')
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.public_path = 'public/'

if Rails.env.production?
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(ENV['AWS_S3_BUCKET'],
    aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    aws_region: 'eu-west-2'
  )

  SitemapGenerator::Sitemap.public_path = 'tmp/'
  SitemapGenerator::Sitemap.sitemaps_host = 'https://sitemaps.chuspace.com/'
end

SitemapGenerator::Sitemap.create do
  Post.published.order(:published_at).limit(1000).find_each do |post|
    add post_url(post), lastmod: post.published_at, changefreq: 'daily'
  end

  Topic.limit(1000).find_each do |topic|
    add topic_url(topic), changefreq: 'daily'
  end

  User.order(:updated_at).limit(1000).find_each do |user|
    add user_url(user), lastmod: user.updated_at, changefreq: 'daily'
  end
end

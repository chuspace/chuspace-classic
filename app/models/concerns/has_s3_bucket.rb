# typed: ignore
# frozen_string_literal: true

module HasS3Bucket
  extend ActiveSupport::Concern

  included do
    after_create do
      S3Service.create_bucket(bucket: nickname)
    rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
      true
    end

    after_destroy -> { S3Service.delete_bucket(bucket: nickname) }
  end

  def s3_bucket_name
    nickname
  end

  def s3_avatar_url
    "s3://#{s3_bucket_name}/#{avatar}" if avatar?
  end
end

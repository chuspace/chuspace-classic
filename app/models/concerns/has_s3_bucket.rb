# typed: ignore
# frozen_string_literal: true

module HasS3Bucket
  extend ActiveSupport::Concern

  def s3_avatar_url
    "s3://#{S3Service.bucket}/#{avatar}" if avatar?
  end
end

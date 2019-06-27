# typed: true
# frozen_string_literal: true

class MinioService
  extend T::Sig
  attr_reader :minio_client, :bucket

  sig { params(bucket: String).void }
  def initialize(bucket:)
    @bucket = bucket
    @minio_client ||= Aws::S3::Client.new
  end

  sig { params(filename: String, content: IO, content_type: String).returns(Aws::S3::Types::PutObjectOutput) }
  def minio_put(filename, content, content_type)
    minio_client.put_object(
      key: filename,
      body: content,
      bucket: bucket,
      content_type: content_type
    )
  end

  sig { params(filename: String).returns(Aws::S3::Types::GetObjectOutput) }
  def minio_get(filename)
    minio_client.get_object(
      bucket: bucket,
      key: filename,
      response_target: 'download_testobject'
    )
  end

  sig { params(filename: String).returns(Aws::S3::Types::DeleteObjectOutput) }
  def minio_delete(filename)
    minio_client.delete_object(
      bucket: bucket,
      key: filename
    )
  end
end

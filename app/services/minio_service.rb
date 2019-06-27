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

  sig { params(filename: String, file: ActionDispatch::Http::UploadedFile, content_type: String).returns(Seahorse::Client::Response) }
  def put_object(filename:, file:, content_type:)
    minio_client.put_object(
      key: filename,
      body: file.read,
      bucket: bucket,
      content_type: content_type
    )
  end

  sig { params(filename: String).returns(Seahorse::Client::Response) }
  def get_object(filename:)
    minio_client.get_object(
      bucket: bucket,
      key: filename
    )
  end

  sig { params(filename: String).returns(Seahorse::Client::Response) }
  def delete_object(filename:)
    minio_client.delete_object(
      bucket: bucket,
      key: filename
    )
  end

  def create_bucket(name:)
    minio_client.create_bucket(bucket: bucket)
  end
end

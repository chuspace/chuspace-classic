# typed: true
# frozen_string_literal: true

class S3Service
  extend T::Sig

  ALLOWED_TYPES = %i[png gif jpeg jpg]
  MAX_SIZE = 15.megabytes

  sig { params(io: T.untyped, filename: String, bucket: String, size: T.nilable(Integer)).returns(Seahorse::Client::Response) }
  def self.upload(io:, filename:, bucket:, size: MAX_SIZE)
    content_type = MimeMagic.by_path(filename).type
    client.put_object(key: filename, content_type: content_type, bucket: bucket, body: io)
  end

  sig { params(filename: String, bucket: String).returns(Seahorse::Client::Response) }
  def self.remove(filename:, bucket:)
    client.delete_object(key: filename, bucket: bucket)
  end

  sig { params(filename: String, bucket: String).returns(Seahorse::Client::Response) }
  def self.get(filename:, bucket:)
    client.get_object(key: filename, bucket: bucket)
  end

  sig { params(bucket: String).returns(Seahorse::Client::Response) }
  def self.create_bucket(bucket:)
    client.create_bucket(bucket: bucket)
  end

  sig { params(bucket: String).returns(Seahorse::Client::Response) }
  def self.delete_bucket(bucket:)
    client.delete_bucket(bucket: bucket)
  end

  sig { returns(Aws::S3::Client) }
  def self.client
    @client ||= Aws::S3::Client.new
  end
end

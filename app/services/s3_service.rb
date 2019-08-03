# typed: true
# frozen_string_literal: true

class S3Service
  extend T::Sig

  sig { params(io: T.untyped, filename: String).returns(Seahorse::Client::Response) }
  def self.upload(io:, filename:)
    content_type = MiniMime.lookup_by_filename(filename)&.content_type
    client.put_object(key: filename, content_type: content_type, bucket: bucket, body: io)
  end

  sig { params(filename: String).returns(Seahorse::Client::Response) }
  def self.remove(filename:)
    client.delete_object(key: filename, bucket: bucket)
  end

  sig { params(filename: String).returns(Seahorse::Client::Response) }
  def self.get(filename:)
    client.get_object(key: filename, bucket: bucket)
  end

  sig { returns(Aws::S3::Client) }
  def self.client
    @client ||= Aws::S3::Client.new
  end

  def self.bucket
    ENV.fetch('AWS_S3_BUCKET')
  end
end

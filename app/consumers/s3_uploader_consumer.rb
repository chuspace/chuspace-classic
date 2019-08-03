# typed: false
# frozen_string_literal: true

class S3UploaderConsumer < Racecar::Consumer
  subscribes_to 'blobs'

  def process(message)
    payload = JSON.parse(message.value)
    repository = Repository.includes(:author).find(payload['repository_id'])
    blob = repository.blob_at(path: payload['path'])
    bucket = repository.author.nickname

    case payload['action'].to_sym
    when :upload
      S3Service.upload(io: blob.io, filename: blob.path)
    when :remove
      S3Service.remove(filename: blob.path)
    end
  end
end

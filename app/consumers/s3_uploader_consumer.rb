class S3UploaderConsumer < Racecar::Consumer
  subscribes_to 'blobs'

  def process(message)
    payload = JSON.parse(message.value)
    case payload['action'].to_sym
    when :upload
      S3Service.upload(io: payload['io'], filename: payload['path'], bucket: payload['bucket'])
    when :remove
      S3Service.remove(filename: payload['path'], bucket: payload['bucket'])
    end
  end
end

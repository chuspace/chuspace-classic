# frozen_string_literal: true

require 'mini_mime'
class RemoteFileToBlobService
  class URLError < StandardError; end
  class ContentTypeError < StandardError; end

  attr_reader :file

  def initialize(url)
    uri = URI.parse(url)
    fail URLError, 'Invalid file' unless uri.respond_to?(:open)
    @file = uri.open
  end

  def blob
    ActiveStorage::Blob.create_after_upload!(
      io: file,
      filename: filename,
      content_type: mime.content_type
    )
  end

  def filename
    filename = filename_from_header || filename_from_uri
    "#{filename}.#{mime.extension}" unless File.extname(filename).present? || mime.blank?
  end

  def mime
    mime = MiniMime.lookup_by_content_type(file.content_type)
    fail ContentTypeError, 'Invalid content type' unless mime.content_type.match?('image')
    mime
  end

  private
    def filename_from_header
      if file.meta.include? 'content-disposition'
        match = file.meta['content-disposition'].match(/filename="?([^"]+)/)
        match[1] unless match.nil? || match[1].empty?
      end
    end

    def filename_from_uri
      URI.decode(File.basename(file.base_uri.path))
    end
end

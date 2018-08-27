# frozen_string_literal: true

require 'mini_mime'
require 'open-uri'

class RemoteFileToBlobService
  class DownloadError < StandardError; end
  class URIError < StandardError; end
  class ContentTypeError < StandardError; end

  attr_reader :uri, :file
  HEADERS = { 'User-Agent' => 'chuspace.com' }.freeze

  def initialize(remote_url)
    @uri = process_uri(remote_url)
    file = Kernel.open(uri.to_s, HEADERS)
    @file = file.is_a?(String) ? StringIO.new(file) : file
    fail DownloadError, 'trying to download a file which is not served over HTTP' unless http?
  end

  def blob
    ActiveStorage::Blob.create_after_upload!(
      io: file,
      filename: filename,
      content_type: mime.content_type
    )
  end

  private
  def process_uri(uri)
    URI.parse(uri)
  rescue URI::InvalidURIError
    uri_parts = uri.split('?')
    encoded_uri = URI.encode(uri_parts.shift, /[^\-_.!~*'()a-zA-Z\d;\/?:@&=+$,]/)
    encoded_uri << '?' << URI.encode(uri_parts.join('?')) if uri_parts.any?
    URI.parse(encoded_uri) rescue fail URIError, "couldn't parse URL"
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

  def filename_from_header
    if file.meta.include? 'content-disposition'
      match = file.meta['content-disposition'].match(/filename="?([^"]+)/)
      match[1] unless match.nil? || match[1].empty?
    end
  end

  def filename_from_uri
    URI.decode(File.basename(file.base_uri.path))
  end

  def http?
    uri.scheme =~ /^https?$/
  end
end

# frozen_string_literal: true

require 'down/http'

class RemoteFileToBlobService
  attr_reader :file

  HEADERS = { 'User-Agent' => 'chuspace v1' }.freeze

  def initialize(remote_url)
    @file = Down::Http.download(remote_url, headers: HEADERS)
  rescue StandardError => e
    fail "Download failed: #{e.message}"
  end

  def to_blob
    ActiveStorage::Blob.create_after_upload!(
      io: file, filename: file.original_filename, content_type: file.content_type
    )
  end
end

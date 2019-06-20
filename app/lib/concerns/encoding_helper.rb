# typed: true
# frozen_string_literal: true

require 'active_support/concern'
require 'charlock_holmes'

module EncodingHelper
  extend ActiveSupport::Concern

  ENCODING_CONFIDENCE_THRESHOLD = 40

  def encode!(blob)
    return nil unless blob.respond_to? :force_encoding

    # if blob is utf-8 encoding, just return it
    blob.force_encoding('UTF-8')
    return blob if blob.valid_encoding?

    # return blob if blob type is binary
    detect = detect(blob)
    return blob.force_encoding('BINARY') if detect && detect[:type] == :binary

    # force detected encoding if we have sufficient confidence.
    if detect && detect[:encoding] && detect[:confidence] > ENCODING_CONFIDENCE_THRESHOLD
      blob.force_encoding(detect[:encoding])
    end

    # encode and clean the bad chars
    blob.replace clean(blob)
  rescue StandardError
    encoding = detect ? detect[:encoding] : 'unknown'
    "--broken encoding: #{encoding}"
  end

  def detect(blob)
    CharlockHolmes::EncodingDetector.detect(blob)
  end

  def encode_utf8(blob)
    detect = CharlockHolmes::EncodingDetector.detect(blob)
    detect ? CharlockHolmes::Converter.convert(blob, detect[:encoding], 'UTF-8') : clean(blob)
  end

  private

  def clean(blob)
    blob.encode('UTF-16BE', undef: :replace, invalid: :replace, replace: '').encode('UTF-8').gsub(
      "\0".encode('UTF-8'),
      ''
    )
  end
end

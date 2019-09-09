# typed: ignore
# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  TWITTER_USERNAME_REGEXP = /([A-Za-z0-9_]{1,15})/i
  TWITTER_URL_REGEXP = %r{\Ahttps?://(?:www\.)?twitter.com/#{TWITTER_USERNAME_REGEXP}\z}i

  def initialize(options)
    options[:protocols] ||= options.delete(:protocol) || options.delete(:with) || options.delete(:in)
    super
  end

  def validate_each(record, attribute, value)
    uri = as_uri(value)
    tld_requirement_fullfilled = check_tld_requirement(value)
    record.errors.add(attribute) unless uri && value.to_s =~ uri_regexp && tld_requirement_fullfilled

    if options[:twitter]
      match = value&.match(TWITTER_URL_REGEXP)
      record.errors.add(attribute) unless match && !match[1].nil?
    end
  end

  private

  def check_validity!
    raise ArgumentError, 'At least one URI protocol is required' if protocols.empty?
  end

  def protocols
    Array.wrap(options[:protocols] || %w[http https])
  end

  def uri_regexp
    @uri_regexp ||= /\A#{URI::Parser.new.make_regexp(protocols)}\z/
  end

  def check_tld_requirement(value)
    host =
      begin
        URI.parse(value.to_s).host
      rescue StandardError
        value
      end
    options[:require_tld] === true ? host =~ /.(\.)\w+/ : true
  end

  def as_uri(value)
    if value.present?
      begin
        URI.parse(value.to_s)
      rescue StandardError
        nil
      end
    end
  end
end

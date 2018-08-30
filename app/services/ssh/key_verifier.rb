# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'digest/md5'
require 'digest/sha1'

module SSH
  class KeyVerifier
    include Service
    attr_reader :key

    SSH_TYPES = {
      'ssh-rsa' => 'rsa',
      'ssh-dss' => 'dsa',
      'ssh-ed25519' => 'ed25519',
      'ecdsa-sha2-nistp256' => 'ecdsa',
      'ecdsa-sha2-nistp384' => 'ecdsa',
      'ecdsa-sha2-nistp521' => 'ecdsa',
    }

    SSH_CONVERSION = { 'rsa' => ['e', 'n'], 'dsa' => ['p', 'q', 'g', 'pub_key'] }
    SSH2_LINE_LENGTH = 70 # +1 (for line wrap '/' character) must be <= 72

    def initialize(key:)
      @key = key
    end

    def call
      ssh_type, encoded_key = parse_ssh_public_key(key)
      sections = unpacked_byte_array(ssh_type, encoded_key)
      case ssh_type
      when 'ssh-rsa', 'ssh-dss'
        sections.size == SSH_CONVERSION[SSH_TYPES[ssh_type]].size
      when 'ssh-ed25519'
        sections.size == 1 && sections[0].num_bytes == 32 # https://tools.ietf.org/id/draft-bjh21-ssh-ed25519-00.html#rfc.section.4
      when 'ecdsa-sha2-nistp256', 'ecdsa-sha2-nistp384', 'ecdsa-sha2-nistp521'
        sections.size == 2                                # https://tools.ietf.org/html/rfc5656#section-3.1
        else
        false
      end
    rescue
      false
    end

    def ssh_public_key_bits(ssh_public_key)
      unpacked_byte_array(*parse_ssh_public_key(ssh_public_key)).last.num_bytes * 8
    end

    private

    def unpacked_byte_array(ssh_type, encoded_key)
      prefix = [ssh_type.length].pack('N') + ssh_type
      decoded = Base64.decode64(encoded_key)

      # Base64 decoding is too permissive, so we should validate if encoding is correct
      unless Base64.encode64(decoded).gsub("\n", '') == encoded_key && decoded.slice!(0, prefix.length) == prefix
        raise PublicKeyError, 'validation error'
      end

      data = []
      until decoded.empty?
        front = decoded.slice!(0, 4)
        size = front.unpack('N').first
        segment = decoded.slice!(0, size)
        unless front.length == 4 && segment.length == size
          raise PublicKeyError, 'byte array too short'
        end
        data << OpenSSL::BN.new(segment, 2)
      end
      data
    end

    def parse_ssh_public_key(public_key)
      raise PublicKeyError, 'newlines are not permitted between key data' if public_key =~ /\n(?!$)/

      parsed = public_key.split(' ')
      parsed.each_with_index do |el, index|
        return parsed[index..(index + 1)] if SSH_TYPES[el]
      end
      raise PublicKeyError, 'cannot determine key type'
    end

    class PublicKeyError < StandardError; end
  end
end

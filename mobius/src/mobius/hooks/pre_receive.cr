require "yaml"
require "./common.cr"

module Mobius
  module Hooks
    class PreReceive
      include Mobius::Hooks::Common

      getter refs : Array(String)
      getter user_id : String
      getter repo_id : String

      PRE_RECEIVE_CHECK_ENDPOINT = "/mobius/pre_receive"

      MAX_SIZE = 1024*1024
      MAX_IMAGE_SIZE = 25
      MAX_POST_SIZE = 0.5

      BINARY_MIME = "application/octet-stream"
      CHAR_ENCODINGS = {
        "%!PS-Adobe-" => { type: "application/postscript", binary: false },
        "\x89PNG\r\n\u001A\n" => { type: "image/png", binary: true },
        "GIF87a" => { type: "image/gif", binary: true },
        "GIF89a" => { type: "image/gif", binary: true },
        "%PDF-" => { type: "application/pdf", binary: true },
        "\0\0\xfe\xff" => { type: "UTF-32", binary: false },
        "\xff\xfe\0\0" => { type: "UTF-32", binary: false },
        "\xFF\xD8\xFF" => { type: "image/jpeg", binary: true },
        "\xfe\xff" => { type: "UTF-16", binary: false },
        "\xff\xfe" => { type: "UTF-16", binary: false }
      }

      def initialize
        @refs = STDIN.gets_to_end.split(" ", remove_empty: true)
        @repo_id = ENV.fetch("GIT_REPO_ID", "")
        @user_id = ENV.fetch("GIT_USER_ID", "")
      end

      def blob_names
        names = `git ls-tree --name-only -r #{refs[1]}`
        names.split("\n", remove_empty: true).reject(&.blank?)
      end

      def exec
        error_messages = [] of String

        blob_names.each do |file|
          blob = `git show #{refs[1]}:'#{file}'`
          errors = validate_encoding(file, blob)

          if file.ends_with?(".md")
            YAML.parse(blob)
            response = validate(file, blob)

            unless response.body.try &.blank?
              print "ERROR: #{response.body}"
              exit 1
            end
          end

          error_messages += errors
        rescue ex : YAML::ParseException
          print "ERROR: Malformed frontmatter"
          exit 1
        end

        if error_messages.any?
          print(error_messages.join("\n"))
          exit 1
        else
          exit 0
        end
      end

      private def encoding(blob)
        buf = blob.to_unsafe
        buf_size = blob.bytesize

        default_encoding = {
          type: "plain/text",
          binary: !blob.try &.valid_encoding?,
          size: (buf_size / MAX_SIZE.to_f).try &.round(2)
        }

        text = CHAR_ENCODINGS.keys.find { |text| buf.memcmp(text.to_unsafe, text.bytesize) == 0 }
        return default_encoding.merge(CHAR_ENCODINGS[text]) if text

        buf_size = MAX_SIZE if MAX_SIZE < buf_size
        return default_encoding.merge({ type: BINARY_MIME, binary: true }) if !!LibC.memchr(buf, 0, buf_size)

        default_encoding
      end

      private def validate_encoding(file : String, blob)
        errors = [] of String

        encoding = encoding(blob)
        mime_type = encoding[:type]

        if !mime_type.match(/image|text/)
          errors << "#{file}: Unsupported file format"
        end

        if mime_type.includes?("image") && encoding[:size] > MAX_IMAGE_SIZE
          errors << "#{file}: Max image size is #{MAX_IMAGE_SIZE}MB"
        end

        if mime_type.includes?("text") && encoding[:size] > MAX_POST_SIZE
          errors << "#{file}: Max post size is #{MAX_POST_SIZE}MB"
        end

        errors
      end

      private def validate(name : String, blob : String)
        HTTP::Client.post(
          "#{base_url}#{PRE_RECEIVE_CHECK_ENDPOINT}",
          headers: HTTP_HEADERS,
          form: {
            "token" => token,
            "repository_id" => repo_id,
            "author_id" => user_id,
            "blob_name" => name,
            "blob" => blob
          }
        )
      end

      private def print(message : String)
        puts
        puts message
        puts
      end
    end
  end
end

Mobius::Hooks::PreReceive.new.exec

require "yaml"

module Mobius
  module Hooks
    class PreReceive
      getter refs : Array(String)

      class Post
        YAML.mapping(
          title: String,
          slug: String?,
          status: String?,
          parent_slug: String?,
          excerpt: String?,
          tag_slugs: Array(String?)?,
          published_at: String?
        )
      end

      MAX_SIZE = 1024*1024
      MAX_IMAGE_SIZE = 25
      MAX_POST_SIZE = 0.5

      IGNORED_FILES = %w(.gitignore .gitkeep .keep)

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
      end

      def blob_names
        names = `git ls-tree --name-only -r #{refs[1]}`
        names.split("\n", remove_empty: true).reject(&.blank?)
      end

      def exec
        errors = [] of Hash(String, String)

        blob_names.each do |file|
          blob = `git show #{refs[1]}:'#{file}'`
          encoding = encoding(blob)
          mime_type = encoding[:type]

          if encoding[:binary] && !mime_type.includes?("image")
            errors << { file => "Unsupported file format" }
            next
          end

          if mime_type.includes?("image") && encoding[:size] > MAX_IMAGE_SIZE
            errors << { file => "Max image size is #{MAX_IMAGE_SIZE}MB" }
            next
          end

          next if mime_type.includes?("image")

          if mime_type.includes?("text") && encoding[:size] > MAX_POST_SIZE
            errors << { file =>  "Max post size is #{MAX_POST_SIZE}MB" }
            next
          end

          next if safelisted?(file)

          Post.from_yaml(blob)
        rescue YAML::ParseException
          errors << { file =>  "Invalid frontmatter" }
        end

        errors.empty?
      end

      private def safelisted?(file)
        IGNORED_FILES.includes?(file)
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

        return default_encoding
      end
    end
  end
end

Mobius::Hooks::PreReceive.new.exec

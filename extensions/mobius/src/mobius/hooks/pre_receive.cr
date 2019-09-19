require "dotenv"
require "db"
require "pg"

Dotenv.load!("/home/git/chuspace.com/current/.env")

module Mobius
  module Hooks
    class PreReceive
      getter refs : Array(String)

      MAX_SIZE = 1024*1024
      MAX_IMAGE_SIZE = 15
      MAX_POST_SIZE = 0.5
      FILE_NAME_RANGE = 1..100
      FILENAME_REGEX = /^(?:.+\/)*(.*)(\.[^.]+)$/

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
        names = `git diff --name-only #{refs[0]} #{refs[1]}`
        names.split("\n", remove_empty: true).reject(&.blank?)
      end

      def exec
        errors = [] of String
        publication_id = ENV.fetch("GIT_PUBLICATION_ID", "")
        user_id = ENV.fetch("GIT_USER_ID", "")

        blob_names.each do |file|
          blob = `git show #{refs[1]}:'#{file}'`
          encoding = encoding(blob)
          mime_type = encoding[:type]

          errors << "#{file}: Invalid file name, should be lowercase, no spaces and separated by a hyphen" unless FILENAME_REGEX.match(file)
          errors << "#{file}: File name out of range, should be #{FILE_NAME_RANGE} chars" unless FILE_NAME_RANGE.includes?(file.size)

          case mime_type
          when "text/plain"
            errors << "#{file}: Max post size is #{MAX_POST_SIZE}MB" if encoding[:size] > MAX_POST_SIZE
          when "image/gif", "image/png", "image/jpeg"
            errors << "#{file}: Max image size is #{MAX_IMAGE_SIZE}MB" if encoding[:size] > MAX_IMAGE_SIZE
          else
            errors << "#{file}: Unsupported file format"
          end
        end

        database = DB.open ENV.fetch("DATABASE_URL")
        unauthorized_role = 0

        sql = <<-STRING
          SELECT
            "posts"."blob_path"
          FROM
            "posts"
            INNER JOIN "publications" ON "publications"."id" = "posts"."publication_id"
            INNER JOIN "collaborators" ON "collaborators"."publication_id" = "publications"."id"
            INNER JOIN "users" ON "users"."id" = "collaborators"."user_id"
          WHERE
            "posts"."blob_path" IN ('#{blob_names.join("','")}')
            AND "collaborators"."user_id" = $1
            AND "collaborators"."role" = $2
            AND "posts"."author_id" != $1
        STRING

        response = database.query sql, user_id, unauthorized_role do |response|
          response.each do
            errors << "#{response.read(String)}: You are only allowed to edit your own posts."
          end
        end

        if errors.any?
          print(errors.join("\n"))
          exit 1
        else
          exit 0
        end
      end

      private def encoding(blob)
        buf = blob.to_unsafe
        buf_size = blob.bytesize

        default_encoding = {
          type: "text/plain",
          binary: !blob.try &.valid_encoding?,
          size: (buf_size / MAX_SIZE.to_f).try &.round(2)
        }

        text = CHAR_ENCODINGS.keys.find { |text| buf.memcmp(text.to_unsafe, text.bytesize) == 0 }
        return default_encoding.merge(CHAR_ENCODINGS[text]) if text

        buf_size = MAX_SIZE if MAX_SIZE < buf_size
        return default_encoding.merge({ type: BINARY_MIME, binary: true }) if !!LibC.memchr(buf, 0, buf_size)

        default_encoding
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

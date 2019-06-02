require "http/client"
require "dotenv"

Dotenv.load!("/Users/gaurav/personal/chuspace/.env")

module Mobius
  module Hooks
    module Common
      DEFAULT_REF = "refs/heads/master"
      HTTP_HEADERS = HTTP::Headers{
        "User-Agent" => "Mobius",
        "Content-Type" => "application/json"
      }

      private def base_url
        ENV.fetch("CHUSPACE_URL", "")
      end

      private def token
        ENV.fetch("MOBIUS_TOKEN", "")
      end

      private def frontmatter(blob : String)
        io = IO::Memory.new(blob)
        expect_sequence(io, "---\n")
        front = IO::Memory.new()

        while ( char = next_char(io) )
          front << char
          next if ( char != '\n' )
          next if ( !test_sequence(io, "---\n") )

          break
        end

        raise MalformedError.eof() if ( next_char(io).nil? )
        io.seek(-1, IO::Seek::Current)

        skip_newlines(io) if ( skip_newlines )
        front = front.to_s
        front = front.strip if ( strip )
        yield(front, io)
      end
    end
  end
end

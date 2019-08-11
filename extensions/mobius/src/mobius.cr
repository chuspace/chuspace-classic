
require "db"
require "pg"
require "dotenv"
require "./mobius/auth.cr"
require "./mobius/shell.cr"

Dotenv.load!(ENV.fetch("CHUSPACE_ENV_FILE_PATH", "/Users/gaurav/personal/chuspace/.env"))

module Mobius
  VERSION = "0.1.0"

  def self.database
    DB.open ENV.fetch("DATABASE_URL")
  end

  def self.call(args : Array(String) = [] of String)
    case args[0]
    when "auth"
      Mobius::Auth.call(args[1])
    when "shell"
      Mobius::Shell.call(args[1])
    end
  rescue IndexError
  end
end


Mobius.call(ARGV)

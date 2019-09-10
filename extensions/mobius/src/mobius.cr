
require "db"
require "pg"
require "dotenv"
require "./mobius/auth.cr"
require "./mobius/shell.cr"

Dotenv.load!("/home/git/chuspace.com/current/.env")

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
